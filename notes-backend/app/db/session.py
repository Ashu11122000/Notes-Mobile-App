"""
===============================================================================
File: app/db/session.py
===============================================================================

Enterprise SQLAlchemy Session Management

Responsibilities
-------------------------------------------------------------------------------
- Create and configure the SQLAlchemy engine.
- Configure optimized connection pooling.
- Create the session factory.
- Provide FastAPI database dependency.
- Centralize database connection management.

Notes
-------------------------------------------------------------------------------
- Optimized for PostgreSQL.
- SQLAlchemy 2.x compatible.
- Docker friendly.
- Resource-efficient for local development.
- Production ready.
===============================================================================
"""

from __future__ import annotations

from collections.abc import Generator

from sqlalchemy import Engine, create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config import settings

__all__ = (
    "engine",
    "SessionLocal",
    "get_db",
)


# =============================================================================
# Engine Factory
# =============================================================================


def create_database_engine() -> Engine:
    """
    Create and configure the SQLAlchemy engine.

    Connection pool values should come from application settings so they can
    differ between development and production.
    """

    return create_engine(
        settings.DATABASE_URL,

        # SQLAlchemy 2.x
        future=True,

        # SQL Logging
        echo=settings.DEBUG,

        # Connection Pool
        pool_size=settings.DB_POOL_SIZE,
        max_overflow=settings.DB_MAX_OVERFLOW,
        pool_timeout=settings.DB_POOL_TIMEOUT,
        pool_recycle=settings.DB_POOL_RECYCLE,
        pool_pre_ping=settings.DB_POOL_PRE_PING,
        pool_use_lifo=True,

        # Transaction Safety
        pool_reset_on_return="rollback",
    )


# =============================================================================
# Engine
# =============================================================================

engine: Engine = create_database_engine()


# =============================================================================
# Session Factory
# =============================================================================

SessionLocal = sessionmaker(
    bind=engine,
    class_=Session,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)


# =============================================================================
# FastAPI Dependency
# =============================================================================


def get_db() -> Generator[Session, None, None]:
    """
    Yield one SQLAlchemy session per request.

    FastAPI automatically closes the generator after the response,
    ensuring that connections are returned to the pool.
    """

    session = SessionLocal()

    try:
        yield session

    finally:
        session.close()