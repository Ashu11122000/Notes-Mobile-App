"""
===============================================================================
File: conftest.py
===============================================================================

Pytest Configuration

Responsibilities
----------------------------------------------------------------------------
- Configure the SQLite test database.
- Override the application's database dependency.
- Provide reusable TestClient fixtures.
- Ensure database isolation between tests.

Architecture
----------------------------------------------------------------------------
Pytest
   │
   ▼
SQLite Test Database
   │
   ▼
Dependency Override
   │
   ▼
FastAPI TestClient

Notes
----------------------------------------------------------------------------
- Uses SQLite for fast and isolated testing.
- Creates a fresh database for every test.
- Automatically overrides the production database dependency.
"""

from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.db.base import Base
from app.db.session import get_db
from app.main import app

# =============================================================================
# SQLite Test Database
# =============================================================================

TEST_DATABASE_URL = "sqlite:///./test.db"

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


app.dependency_overrides[get_db] = override_get_db

# =============================================================================
# Test Client Fixture
# =============================================================================


@pytest.fixture(scope="function")
def test_client() -> Generator[TestClient, None, None]:
    """
    Create a fresh database and TestClient for each test.

    This guarantees test isolation.
    """

    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    with TestClient(app) as client:
        yield client

    Base.metadata.drop_all(bind=engine)