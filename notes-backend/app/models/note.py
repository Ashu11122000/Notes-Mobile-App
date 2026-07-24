"""
===============================================================================
File: note.py
===============================================================================

Note Model

Responsibilities
----------------------------------------------------------------------------
- Represent the Notes table in PostgreSQL.
- Store note information owned by authenticated users.
- Define relationships with the User model.
- Provide automatic timestamp management.

Relationships
----------------------------------------------------------------------------
User (1) ──────────────── (*) Notes

Each user can own multiple notes.
Each note belongs to exactly one user.

Notes
----------------------------------------------------------------------------
- Compatible with SQLAlchemy 2.x Typed ORM.
- Uses cascading delete when a user is removed.
- Automatically maintains creation and update timestamps.
"""

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

if TYPE_CHECKING:
    from app.models.user import User


class Note(Base):
    """
    SQLAlchemy model representing a user's note.
    """

    __tablename__ = "notes"

    # =========================================================================
    # Primary Key
    # =========================================================================

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        index=True,
    )

    # =========================================================================
    # Note Information
    # =========================================================================

    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    content: Mapped[str | None] = mapped_column(
        String,
        nullable=True,
    )

    # =========================================================================
    # Ownership
    # =========================================================================

    owner_id: Mapped[int] = mapped_column(
        ForeignKey(
            "users.id",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    # =========================================================================
    # Audit Fields
    # =========================================================================

    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        nullable=False,
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )

    # =========================================================================
    # Relationships
    # =========================================================================

    owner: Mapped["User"] = relationship(
        back_populates="notes",
    )