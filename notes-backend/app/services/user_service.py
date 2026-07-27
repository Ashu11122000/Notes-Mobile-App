"""
===============================================================================
File: user_service.py
===============================================================================

Enterprise User Service

Responsibilities
-------------------------------------------------------------------------------
- User business logic
- Registration
- User lookup
- Database interaction
- SQLAlchemy transaction management
===============================================================================
"""

from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models.user import User

__all__ = (
    "create_user",
    "get_user_by_email",
    "get_user_by_id",
)


class UserAlreadyExistsError(Exception):
    """Raised when a user already exists."""


# =============================================================================
# Create User
# =============================================================================


def create_user(
    db: Session,
    email: str,
    password: str,
) -> User:
    """
    Create a new user.
    """

    user = User(
        email=email,
        hashed_password=hash_password(password),
    )

    db.add(user)

    try:
        db.commit()

    except IntegrityError as exc:
        db.rollback()
        raise UserAlreadyExistsError(
            "A user with this email already exists."
        ) from exc

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
    Retrieve a user by email.
    """

    stmt = (
        select(User)
        .where(User.email == email)
        .limit(1)
    )

    return db.scalar(stmt)


# =============================================================================
# Get User By ID
# =============================================================================


def get_user_by_id(
    db: Session,
    user_id: int,
) -> User | None:
    """
    Retrieve a user by ID.
    """

    return db.get(User, user_id)