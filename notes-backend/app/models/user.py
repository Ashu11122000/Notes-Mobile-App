from __future__ import annotations

"""
===============================================================================
File: user.py
===============================================================================

User Model

Responsibilities
----------------------------------------------------------------------------
- Represent application users.
- Store authentication credentials.
- Manage user roles and account status.
- Define relationships with Notes.

Relationships
----------------------------------------------------------------------------
User (1) ──────────────── (*) Notes

Each user can own multiple notes.
Each note belongs to exactly one user.

Notes
----------------------------------------------------------------------------
- Compatible with SQLAlchemy 2.x Typed ORM.
- Passwords are stored as secure bcrypt hashes.
- Supports Role-Based Access Control (RBAC).
"""

from typing import TYPE_CHECKING

from sqlalchemy import Boolean, Index, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

__all__ = ("User",)

if TYPE_CHECKING:
    from app.models.note import Note

# =============================================================================
# Role Constants
# =============================================================================

ROLE_USER = "user"
ROLE_ADMIN = "admin"


class User(Base):
    """
    SQLAlchemy model representing an authenticated user.
    """

    __tablename__ = "users"

    __table_args__ = (
        Index("ix_users_email", "email"),
    )

    # =========================================================================
    # Primary Key
    # =========================================================================

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True,
    )

    # =========================================================================
    # Authentication
    # =========================================================================

    email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        index=True,
        nullable=False,
    )

    hashed_password: Mapped[str] = mapped_column(
        String,
        nullable=False,
    )

    # =========================================================================
    # Authorization
    # =========================================================================

    role: Mapped[str] = mapped_column(
        String(50),
        default=ROLE_USER,
        nullable=False,
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False,
    )

    # =========================================================================
    # Relationships
    # =========================================================================

    notes: Mapped[list["Note"]] = relationship(
        back_populates="owner",
        cascade="all, delete-orphan",
        passive_deletes=True,
        lazy="selectin",
    )

    # =========================================================================
    # Debug Representation
    # =========================================================================

    def __repr__(self) -> str:
        return (
            f"User(id={self.id!r}, "
            f"email={self.email!r}, "
            f"role={self.role!r}, "
            f"is_active={self.is_active!r})"
        )