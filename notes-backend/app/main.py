from __future__ import annotations

"""
===============================================================================
File: main.py
===============================================================================

Notes Backend API

Responsibilities
-------------------------------------------------------------------------------
- Create and configure the FastAPI application.
- Register middleware.
- Register API routers.
- Manage application startup/shutdown.
- Expose health endpoints.
- Configure OpenAPI documentation.

Architecture
-------------------------------------------------------------------------------
Flutter
    │
    ▼
FastAPI
    │
    ▼
Service Layer
    │
    ▼
SQLAlchemy
    │
    ▼
PostgreSQL

Compatible With
-------------------------------------------------------------------------------
- FastAPI
- SQLAlchemy 2.x
- Alembic
- Docker
- Flutter
- Pydantic V2
===============================================================================
"""

import logging
from contextlib import asynccontextmanager
from typing import Any

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text

from app.api.routes import auth, note
from app.core.config import settings
from app.db.session import SessionLocal

__all__ = ("app",)

# =============================================================================
# Constants
# =============================================================================

API_PREFIX = "/api/v1"
API_VERSION = "1.0.0"

OPENAPI_TAGS = [
    {
        "name": "Authentication",
        "description": "Authentication endpoints.",
    },
    {
        "name": "Notes",
        "description": "Notes CRUD operations.",
    },
]

logger = logging.getLogger(__name__)

# =============================================================================
# Lifespan
# =============================================================================


@asynccontextmanager
async def lifespan(_: FastAPI):
    """
    Application startup/shutdown.

    Database schema management should be performed using Alembic,
    not Base.metadata.create_all().
    """

    logger.info(
        "Starting %s (%s)",
        settings.APP_NAME,
        settings.ENVIRONMENT,
    )

    yield

    logger.info("Stopping %s", settings.APP_NAME)


# =============================================================================
# FastAPI Application
# =============================================================================

app = FastAPI(
    title=settings.APP_NAME,
    version=API_VERSION,
    description="""
Production-ready RESTful backend.

Features

- JWT Authentication
- User Management
- Notes CRUD
- Pagination
- RBAC
- Docker Ready
- PostgreSQL
- SQLAlchemy 2.x
- Alembic
""",
    debug=settings.DEBUG,
    lifespan=lifespan,
    openapi_tags=OPENAPI_TAGS,
    docs_url="/docs" if settings.IS_DEVELOPMENT else None,
    redoc_url="/redoc" if settings.IS_DEVELOPMENT else None,
)

# =============================================================================
# Middleware
# =============================================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =============================================================================
# Root Endpoint
# =============================================================================


@app.get(
    "/",
    tags=["System"],
    summary="API Root",
)
def root() -> dict[str, Any]:
    """
    Root endpoint.
    """

    return {
        "service": settings.APP_NAME,
        "version": API_VERSION,
        "environment": settings.ENVIRONMENT,
        "status": "running",
        "docs": "/docs" if settings.IS_DEVELOPMENT else None,
    }


# =============================================================================
# Health Check
# =============================================================================


@app.get(
    "/health",
    tags=["System"],
    summary="Health Check",
)
def health() -> dict[str, str]:
    """
    Health endpoint used by Docker.
    """

    database_status = "healthy"

    try:
        with SessionLocal() as db:
            db.execute(text("SELECT 1"))
    except Exception:
        database_status = "unhealthy"

    return {
        "status": "healthy",
        "database": database_status,
        "environment": settings.ENVIRONMENT,
        "version": API_VERSION,
    }


# =============================================================================
# Routers
# =============================================================================

app.include_router(
    auth.router,
    prefix=API_PREFIX,
)

app.include_router(
    note.router,
    prefix=API_PREFIX,
)