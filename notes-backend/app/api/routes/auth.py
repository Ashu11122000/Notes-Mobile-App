"""
===============================================================================
File: auth.py
===============================================================================

Authentication Routes

Responsibilities
----------------------------------------------------------------------------
- Register new users.
- Authenticate existing users.
- Generate JWT access tokens.
- Return authenticated user information.
- Delegate business logic to the service layer.

Architecture
----------------------------------------------------------------------------
Client
   │
   ▼
Authentication Routes
   │
   ▼
User Service
   │
   ▼
Database

Notes
----------------------------------------------------------------------------
- Compatible with FastAPI.
- JWT Authentication.
- Swagger/OpenAPI documented.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.core.security import create_access_token, verify_password
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserLogin, UserResponse
from app.services.user_service import create_user, get_user_by_email

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


# =============================================================================
# Register
# =============================================================================


@router.post(
    "/register",
    status_code=status.HTTP_201_CREATED,
    summary="Register User",
    description="Create a new user account.",
)
def register(
    user: UserCreate,
    db: Session = Depends(get_db),
):
    """
    Register a new user.
    """

    existing_user = get_user_by_email(
        db=db,
        email=user.email,
    )

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A user with this email already exists.",
        )

    new_user = create_user(
        db=db,
        email=user.email,
        password=user.password,
    )

    return {
        "message": "User registered successfully.",
        "user_id": new_user.id,
    }


# =============================================================================
# Login
# =============================================================================


@router.post(
    "/login",
    summary="Login User",
    description="Authenticate a user and return a JWT access token.",
)
def login(
    user: UserLogin,
    db: Session = Depends(get_db),
):
    """
    Authenticate a user.
    """

    db_user = get_user_by_email(
        db=db,
        email=user.email,
    )

    if db_user is None or not verify_password(
        user.password,
        db_user.hashed_password,
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
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
    summary="Get Current User",
    description="Return the currently authenticated user.",
)
def get_me(
    current_user: User = Depends(get_current_user),
):
    """
    Retrieve the authenticated user's profile.
    """

    return current_user