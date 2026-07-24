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
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models.user import User


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
        db: Database session.
        email: User email address.
        password: Plain-text password.

    Returns:
        Newly created User object.

    Raises:
        HTTPException:
            If a user with the same email already exists.
    """

    existing_user = get_user_by_email(
        db=db,
        email=email,
    )

    if existing_user is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A user with this email already exists.",
        )

    user = User(
        email=email,
        hashed_password=hash_password(password),
        role="user",
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
        db: Database session.
        email: User email.

    Returns:
        User object if found, otherwise None.
    """

    return (
        db.query(User)
        .filter(User.email == email)
        .first()
    )


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
        db: Database session.
        user_id: User ID.

    Returns:
        User object if found, otherwise None.
    """

    return (
        db.query(User)
        .filter(User.id == user_id)
        .first()
    )