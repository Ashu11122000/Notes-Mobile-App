"""
===============================================================================
File: main.py
===============================================================================

Team Productivity Platform API

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
- Compatible with FastAPI.
- SQLAlchemy 2.x.
- Pydantic V2.
- Docker Ready.
- Flutter Ready.
"""

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import auth, note
from app.core.config import settings
from app.db.base import Base
from app.db.session import engine

# Import models so SQLAlchemy registers them before create_all()
from app.models.note import Note  # noqa: F401
from app.models.user import User  # noqa: F401


# =============================================================================
# Application Lifespan
# =============================================================================


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Execute startup and shutdown events.

    Startup:
        - Create database tables.

    Shutdown:
        - Reserved for future cleanup tasks.
    """

    Base.metadata.create_all(bind=engine)

    yield


# =============================================================================
# FastAPI Application
# =============================================================================


app = FastAPI(
    title="Notes App Backend",
    description="""
Production-ready RESTful backend built with FastAPI.

### Features

- JWT Authentication
- User Management
- Notes CRUD
- Pagination
- Role-Based Access Control (RBAC)
- Docker Support
- Swagger Documentation

Designed for Flutter, Web and REST API clients.
""",
    version="1.0.0",
    debug=settings.DEBUG,
    lifespan=lifespan,
)

# =============================================================================
# Middleware
# =============================================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",  # Next.js
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
def root():
    """
    Root endpoint.
    """

    return {
        "service": settings.APP_NAME,
        "version": "1.0.0",
        "status": "running",
    }


# =============================================================================
# Health Check
# =============================================================================


@app.get(
    "/health",
    summary="Health Check",
)
def health_check():
    """
    Application health check.
    """

    return {
        "status": "healthy",
    }


# =============================================================================
# API Routes
# =============================================================================

app.include_router(
    auth.router,
    prefix="/api/v1",
)

app.include_router(
    note.router,
    prefix="/api/v1",
)