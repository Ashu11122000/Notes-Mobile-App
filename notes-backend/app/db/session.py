"""
===============================================================================
File: session.py
===============================================================================

Database Session Configuration

Responsibilities
----------------------------------------------------------------------------
- Create the SQLAlchemy engine.
- Configure database connection pooling.
- Create session factory.
- Provide database dependency for FastAPI.
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
- Uses connection pooling for better performance.
- Sessions are automatically closed after each request.
"""

from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config import settings

# =============================================================================
# SQLAlchemy Engine
# =============================================================================

engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    pool_recycle=3600,
    echo=False,
)

# =============================================================================
# Session Factory
# =============================================================================

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)

# =============================================================================
# Database Dependency
# =============================================================================


def get_db() -> Generator[Session, None, None]:
    """
    Provide a database session for each request.

    Yields:
        SQLAlchemy Session

    Automatically closes the session after the request
    finishes, regardless of success or failure.
    """

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()