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

Compatible With
-------------------------------------------------------------------------------
- FastAPI 0.136+
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

from fastapi import FastAPI, Response
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

OPENAPI_TAGS = [
    {
        "name": "Authentication",
        "description": "Authentication and user management endpoints.",
    },
    {
        "name": "Notes",
        "description": "Notes CRUD operations.",
    },
    {
        "name": "System",
        "description": "System and health endpoints.",
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

    Database schema should be managed through Alembic migrations.
    """

    logger.info(
        "Starting %s v%s (%s)",
        settings.APP_NAME,
        settings.APP_VERSION,
        settings.ENVIRONMENT,
    )

    yield

    logger.info("Stopping %s", settings.APP_NAME)


# =============================================================================
# FastAPI Application
# =============================================================================

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
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
    allow_origins=settings.BACKEND_CORS_ORIGINS,
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
    API root endpoint.
    """

    return {
        "service": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "environment": settings.ENVIRONMENT,
        "status": "running",
        "docs": "/docs" if settings.IS_DEVELOPMENT else None,
    }


# =============================================================================
# Health Check
# =============================================================================


@app.api_route(
    "/health",
    methods=["GET", "HEAD"],
    tags=["System"],
    summary="Health Check",
)
def health() -> dict[str, str] | Response:
    """
    Health endpoint used by Docker and load balancers.
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
        "version": settings.APP_VERSION,
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