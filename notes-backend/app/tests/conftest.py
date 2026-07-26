"""
===============================================================================
File: conftest.py
===============================================================================

Pytest Configuration

Responsibilities
----------------------------------------------------------------------------
- Configure an isolated SQLite database for testing.
- Override FastAPI database dependencies.
- Prevent tests from using the production PostgreSQL engine.
- Provide reusable database and TestClient fixtures.
- Ensure complete isolation between test cases.

Notes
----------------------------------------------------------------------------
- Uses a temporary SQLite database.
- Recreates the database schema before every test.
- Ensures zero data leakage between tests.
- Compatible with FastAPI + SQLAlchemy 2.x.
"""

from __future__ import annotations

import tempfile
from collections.abc import Generator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

import app.main as main_module
from app.db.base import Base
from app.db.session import get_db
from app.main import app

# =============================================================================
# Temporary SQLite Database
# =============================================================================

_temp_dir = tempfile.TemporaryDirectory()

TEST_DATABASE_PATH = Path(_temp_dir.name) / "test.db"

TEST_DATABASE_URL = f"sqlite:///{TEST_DATABASE_PATH}"

engine = create_engine(
    TEST_DATABASE_URL,
    connect_args={
        "check_same_thread": False,
    },
)

TestingSessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)

# =============================================================================
# Override FastAPI Engine
# =============================================================================

# Ensure FastAPI startup uses the SQLite engine during tests.
main_module.engine = engine


# =============================================================================
# Database Fixture
# =============================================================================


@pytest.fixture(scope="function")
def db_session() -> Generator[Session, None, None]:
    """
    Create a brand-new database schema for every test.

    This guarantees complete test isolation.
    """

    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    db = TestingSessionLocal()

    try:
        yield db
    finally:
        db.close()

        Base.metadata.drop_all(bind=engine)


# =============================================================================
# Dependency Override
# =============================================================================


def override_get_db() -> Generator[Session, None, None]:
    """
    Override the application's database dependency.
    """

    db = TestingSessionLocal()

    try:
        yield db
    finally:
        db.close()


# =============================================================================
# Test Client
# =============================================================================


@pytest.fixture(scope="function")
def test_client(
    db_session: Session,
) -> Generator[TestClient, None, None]:
    """
    Return a FastAPI TestClient configured to use
    the isolated SQLite database.
    """

    app.dependency_overrides[get_db] = override_get_db

    with TestClient(app) as client:
        yield client

    app.dependency_overrides.clear()


# =============================================================================
# Cleanup
# =============================================================================


@pytest.fixture(scope="session", autouse=True)
def cleanup() -> Generator[None, None, None]:
    """
    Dispose of resources after the complete test session.
    """

    yield

    engine.dispose()
    _temp_dir.cleanup()