"""
===============================================================================
File: user_service.py
===============================================================================

User Service

Responsibilities
----------------------------------------------------------------------------
- Encapsulate all business logic related to users.
- Create new user accounts.
- Retrieve users by email or ID.
- Prevent duplicate registrations.
- Keep API routes thin and focused on HTTP concerns.

Architecture
----------------------------------------------------------------------------
Route
   │
   ▼
Service
   │
   ▼
Database

Notes
----------------------------------------------------------------------------
- Compatible with FastAPI.
- Compatible with SQLAlchemy 2.x.
- Passwords are securely hashed using bcrypt.
"""

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models.user import User

__all__ = (
    "create_user",
    "get_user_by_email",
    "get_user_by_id",
)

# =============================================================================
# Constants
# =============================================================================

_DUPLICATE_EMAIL_MESSAGE = "A user with this email already exists."
_DEFAULT_USER_ROLE = "user"


# =============================================================================
# Create User
# =============================================================================


def create_user(
    db: Session,
    email: str,
    password: str,
) -> User:
    """
    Create a new user account.

    Args:
        db: Active SQLAlchemy database session.
        email: User email address.
        password: Plain-text password.

    Returns:
        The newly created user.

    Raises:
        HTTPException:
            If a user with the given email already exists.
    """

    if get_user_by_email(db=db, email=email) is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=_DUPLICATE_EMAIL_MESSAGE,
        )

    user = User(
        email=email,
        hashed_password=hash_password(password),
        role=_DEFAULT_USER_ROLE,
        is_active=True,
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


# =============================================================================
# Get User By Email
# =============================================================================


def get_user_by_email(
    db: Session,
    email: str,
) -> User | None:
    """
    Retrieve a user by email address.

    Args:
        db: Active SQLAlchemy database session.
        email: User email address.

    Returns:
        The matching User if found; otherwise None.
    """

    statement = (
        select(User)
        .where(User.email == email)
        .limit(1)
    )

    return db.scalar(statement)


# =============================================================================
# Get User By ID
# =============================================================================


def get_user_by_id(
    db: Session,
    user_id: int,
) -> User | None:
    """
    Retrieve a user by primary key.

    Args:
        db: Active SQLAlchemy database session.
        user_id: User identifier.

    Returns:
        The matching User if found; otherwise None.
    """

    return db.get(User, user_id)