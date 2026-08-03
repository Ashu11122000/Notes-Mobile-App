from __future__ import annotations

"""
===============================================================================
File: user.py
===============================================================================

Enterprise User Model

Responsibilities
-------------------------------------------------------------------------------
- Store authenticated users.
- Store authorization information.
- Manage RBAC.
- Define ownership relationship with notes.
- Optimize database indexes for authentication.

Compatible With
-------------------------------------------------------------------------------
- SQLAlchemy 2.x
- PostgreSQL
- Alembic
===============================================================================
"""

from typing import TYPE_CHECKING

from sqlalchemy import (
    Boolean,
    Index,
    Integer,
    String,
    text,
)
from sqlalchemy.orm import (
    Mapped,
    mapped_column,
    relationship,
)

from app.db.base import Base

__all__ = (
    "User",
    "ROLE_USER",
    "ROLE_ADMIN",
)

if TYPE_CHECKING:
    from app.models.note import Note


# =============================================================================
# Roles
# =============================================================================

ROLE_USER = "user"
ROLE_ADMIN = "admin"


class User(Base):
    """
    Authenticated application user.
    """

    __tablename__ = "users"

    __table_args__ = (
        Index("ix_users_email_role", "email", "role"),
    )

    # =========================================================================
    # Primary Key
    # =========================================================================

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
    )

    # =========================================================================
    # Authentication
    # =========================================================================

    email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        nullable=False,
        index=True,
    )

    hashed_password: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    # =========================================================================
    # Authorization
    # =========================================================================

    role: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        server_default=text(f"'{ROLE_USER}'"),
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default=text("true"),
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
    # Debug
    # =========================================================================

    def __repr__(self) -> str:
        return (
            f"User("
            f"id={self.id}, "
            f"email={self.email!r}, "
            f"role={self.role!r}, "
            f"is_active={self.is_active}"
            f")"
        )