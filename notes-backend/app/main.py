"""
===============================================================================
File: main.py
===============================================================================

Notes Backend API

Responsibilities
----------------------------------------------------------------------------
- Create and configure the FastAPI application.
- Configure middleware.
- Register API routers.
- Initialize database tables on application startup.
- Expose health check endpoints.

Architecture
----------------------------------------------------------------------------
                ┌──────────────────────┐
                │      FastAPI App     │
                └──────────┬───────────┘
                           │
          ┌────────────────┴────────────────┐
          │                                 │
 Authentication Routes              Notes Routes
          │                                 │
          └────────────────┬────────────────┘
                           │
                      Service Layer
                           │
                      PostgreSQL DB

Notes
----------------------------------------------------------------------------
- FastAPI
- SQLAlchemy 2.x
- Pydantic V2
- Docker Ready
- Flutter Ready
- Production Ready
"""

from contextlib import asynccontextmanager
from typing import Any

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.trustedhost import TrustedHostMiddleware

from app.api.routes import auth, note
from app.core.config import settings
from app.db.base import Base
from app.db.session import engine

# Ensure SQLAlchemy registers models before metadata creation.
from app.models.note import Note  # noqa: F401
from app.models.user import User  # noqa: F401

__all__ = ("app",)

# =============================================================================
# Constants
# =============================================================================

API_PREFIX = "/api/v1"
API_VERSION = "1.0.0"

OPENAPI_TAGS = [
    {
        "name": "Authentication",
        "description": "Authentication and user management endpoints.",
    },
    {
        "name": "Notes",
        "description": "Notes CRUD operations.",
    },
]

# =============================================================================
# Application Lifespan
# =============================================================================


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Execute application startup and shutdown events.

    Startup
    -------
    - Initialize database schema.

    Shutdown
    --------
    - Reserved for future cleanup operations.
    """

    Base.metadata.create_all(bind=engine)

    yield


# =============================================================================
# FastAPI Application
# =============================================================================

app = FastAPI(
    title=settings.APP_NAME,
    description="""
Production-ready RESTful backend built with FastAPI.

## Features

- JWT Authentication
- User Management
- Notes CRUD
- Pagination
- Role-Based Access Control (RBAC)
- Docker Support
- OpenAPI Documentation

Designed for Flutter, Web and REST API clients.
""",
    version=API_VERSION,
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
    TrustedHostMiddleware,
    allowed_hosts=["*"] if settings.IS_DEVELOPMENT else ["localhost"],
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
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
    summary="API Root",
)
def root() -> dict[str, Any]:
    """
    API root endpoint.
    """

    return {
        "service": settings.APP_NAME,
        "version": API_VERSION,
        "environment": settings.ENVIRONMENT,
        "status": "running",
    }


# =============================================================================
# Health Check
# =============================================================================


@app.get(
    "/health",
    summary="Health Check",
)
def health_check() -> dict[str, str]:
    """
    Application health endpoint.
    """

    return {
        "status": "healthy",
    }


# =============================================================================
# API Routes
# =============================================================================

app.include_router(
    auth.router,
    prefix=API_PREFIX,
)

app.include_router(
    note.router,
    prefix=API_PREFIX,
)