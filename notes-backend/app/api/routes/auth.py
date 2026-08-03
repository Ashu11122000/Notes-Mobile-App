"""
===============================================================================
File: auth.py
===============================================================================

Authentication Routes

Responsibilities
-------------------------------------------------------------------------------
- Register new users.
- Authenticate users.
- Issue JWT access tokens.
- Return authenticated user information.
- Keep HTTP concerns separate from business logic.

Compatible With
-------------------------------------------------------------------------------
- FastAPI 0.136+
- SQLAlchemy 2.x
- Pydantic V2
- JWT Authentication
===============================================================================
"""

from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.core.security import create_access_token, verify_password
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserLogin, UserResponse
from app.services.user_service import (
    UserAlreadyExistsError,
    create_user,
    get_user_by_email,
)

__all__ = ("router",)

# =============================================================================
# Dependency Aliases
# =============================================================================

DBSession = Annotated[Session, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]

# =============================================================================
# Router
# =============================================================================

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)

# =============================================================================
# Constants
# =============================================================================

_AUTH_HEADERS = {
    "WWW-Authenticate": "Bearer",
}

_INVALID_CREDENTIALS = "Invalid email or password."
_USER_INACTIVE = "User account is inactive."
_REGISTER_SUCCESS = "User registered successfully."

# =============================================================================
# Register
# =============================================================================


@router.post(
    "/register",
    status_code=status.HTTP_201_CREATED,
    response_model=dict[str, str | int],
    summary="Register User",
    description="Register a new user account.",
)
def register(
    user: UserCreate,
    db: DBSession,
) -> dict[str, str | int]:
    """
    Register a new user.
    """

    try:
        new_user = create_user(
            db=db,
            email=user.email,
            password=user.password,
        )

    except UserAlreadyExistsError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(exc),
        ) from exc

    return {
        "message": _REGISTER_SUCCESS,
        "user_id": new_user.id,
    }


# =============================================================================
# Login
# =============================================================================


@router.post(
    "/login",
    response_model=dict[str, str],
    summary="Login User",
    description="Authenticate a user and return a JWT access token.",
)
def login(
    user: UserLogin,
    db: DBSession,
) -> dict[str, str]:
    """
    Authenticate a user and return a JWT access token.
    """

    db_user = get_user_by_email(
        db=db,
        email=user.email,
    )

    if (
        db_user is None
        or not verify_password(
            user.password,
            db_user.hashed_password,
        )
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_CREDENTIALS,
            headers=_AUTH_HEADERS,
        )

    if not db_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=_USER_INACTIVE,
        )

    access_token = create_access_token(
        {
            "sub": db_user.email,
            "role": db_user.role,
        }
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
    }


# =============================================================================
# Current User
# =============================================================================


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Current User",
    description="Return the authenticated user's profile.",
)
def get_me(
    current_user: CurrentUser,
) -> User:
    """
    Return the authenticated user.
    """

    return current_user