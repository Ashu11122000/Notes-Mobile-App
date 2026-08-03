from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import (
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    func,
)
from sqlalchemy.orm import (
    Mapped,
    mapped_column,
    relationship,
)

from app.db.base import Base

if TYPE_CHECKING:
    from app.models.user import User


class Note(Base):
    """
    User Note model.
    """

    __tablename__ = "notes"

    __table_args__ = (
        Index(
            "ix_notes_owner_created",
            "owner_id",
            "created_at",
        ),
    )

    # ==========================================================================
    # Primary Key
    # ==========================================================================

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
    )

    # ==========================================================================
    # Note
    # ==========================================================================

    title: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    content: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    # ==========================================================================
    # Ownership
    # ==========================================================================

    owner_id: Mapped[int] = mapped_column(
        ForeignKey(
            "users.id",
            ondelete="CASCADE",
        ),
        nullable=False,
        index=True,
    )

    # ==========================================================================
    # Audit
    # ==========================================================================

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )

    # ==========================================================================
    # Relationships
    # ==========================================================================

    owner: Mapped["User"] = relationship(
        back_populates="notes",
        lazy="selectin",
    )

    # ==========================================================================
    # Representation
    # ==========================================================================

    def __repr__(self) -> str:
        return (
            f"Note("
            f"id={self.id}, "
            f"title={self.title!r}, "
            f"owner_id={self.owner_id}"
            f")"
        )