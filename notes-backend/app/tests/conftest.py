"""
===============================================================================
File: conftest.py
===============================================================================

Pytest Configuration

Responsibilities
----------------------------------------------------------------------------
- Configure an isolated SQLite test database.
- Override FastAPI database dependencies.
- Provide reusable database and TestClient fixtures.
- Ensure complete isolation between test cases.

Notes
----------------------------------------------------------------------------
- Uses SQLite for fast local testing.
- Creates a fresh schema for every test.
- Overrides the production database dependency.
- Compatible with SQLAlchemy 2.x.
"""

from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.base import Base
from app.db.session import get_db
from app.main import app

# =============================================================================
# Test Database
# =============================================================================

TEST_DATABASE_URL = "sqlite://"

engine = create_engine(
    TEST_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)

TestingSessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)

# =============================================================================
# Database Fixture
# =============================================================================


@pytest.fixture(scope="function")
def db_session() -> Generator[Session, None, None]:
    """
    Creates a fresh database session for every test.
    """

    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    session = TestingSessionLocal()

    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=engine)


# =============================================================================
# Dependency Override
# =============================================================================


def override_get_db() -> Generator[Session, None, None]:
    """
    Override the production database dependency.
    """

    db = TestingSessionLocal()

    try:
        yield db
    finally:
        db.close()


# =============================================================================
# Test Client Fixture
# =============================================================================


@pytest.fixture(scope="function")
def test_client(
    db_session: Session,
) -> Generator[TestClient, None, None]:
    """
    Return a FastAPI TestClient using the test database.
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
    Dispose of the SQLAlchemy engine after the test session.
    """

    yield

    engine.dispose()