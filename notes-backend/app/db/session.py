"""
===============================================================================
File: session.py
===============================================================================

Database Session Configuration

Responsibilities
----------------------------------------------------------------------------
- Create the SQLAlchemy engine.
- Configure database connection pooling.
- Create the session factory.
- Provide the database dependency for FastAPI.
- Centralize all database connection management.

Architecture
----------------------------------------------------------------------------
FastAPI Request
       │
       ▼
Dependency Injection (get_db)
       │
       ▼
SQLAlchemy Session
       │
       ▼
PostgreSQL Database

Notes
----------------------------------------------------------------------------
- Compatible with SQLAlchemy 2.x.
- Uses optimized connection pooling for better performance.
- Sessions are automatically closed after each request.
- Designed for production-ready FastAPI applications.
"""

from collections.abc import Generator

from sqlalchemy import Engine, create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config import settings

__all__ = ("engine", "SessionLocal", "get_db")

# =============================================================================
# SQLAlchemy Engine
# =============================================================================

engine: Engine = create_engine(
    settings.DATABASE_URL,
    echo=False,
    future=True,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    pool_timeout=30,
    pool_recycle=3600,
    pool_use_lifo=True,
    pool_reset_on_return="rollback",
)

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
# Database Dependency
# =============================================================================


def get_db() -> Generator[Session, None, None]:
    """
    Provide a database session for the lifetime of a request.

    Yields:
        Session: A SQLAlchemy database session.

    The session is always closed after the request finishes,
    ensuring connections are returned to the pool even if an
    exception occurs.
    """

    db: Session = SessionLocal()

    try:
        yield db
    finally:
        db.close()