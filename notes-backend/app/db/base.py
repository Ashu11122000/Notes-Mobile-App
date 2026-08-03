"""
===============================================================================
File: app/db/base.py
===============================================================================

Enterprise SQLAlchemy Declarative Base

Responsibilities
-------------------------------------------------------------------------------
- Provide the root declarative base for all ORM models.
- Maintain a single metadata registry for the entire application.
- Enable SQLAlchemy 2.x typed declarative mapping.
- Serve as the metadata source for Alembic migrations.
- Support enterprise-scale model organization.

Notes
-------------------------------------------------------------------------------
- All ORM models MUST inherit from Base.
- Keep this class lightweight.
- Shared columns (created_at, updated_at, etc.) should be implemented using
  reusable mixins instead of modifying Base directly.
- This module should never contain business logic.
===============================================================================
"""

from __future__ import annotations

from sqlalchemy import MetaData
from sqlalchemy.orm import DeclarativeBase

# =============================================================================
# Naming Convention
# =============================================================================
#
# Stable constraint names improve:
# - Alembic autogeneration
# - Migration consistency
# - Cross-environment deployments
# - PostgreSQL schema evolution
#
NAMING_CONVENTION: dict[str, str] = {
    "ix": "ix_%(column_0_label)s",
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}


metadata = MetaData(
    naming_convention=NAMING_CONVENTION,
)


class Base(DeclarativeBase):
    """
    Root declarative base for all SQLAlchemy ORM models.

    Every mapped model in the application must inherit from this class.

    The Base class intentionally remains minimal. Reusable functionality
    (timestamps, soft delete, UUIDs, auditing, etc.) should be implemented
    through mixins rather than directly extending Base.
    """

    __abstract__ = True

    metadata = metadata

    __slots__ = ()

    def __repr__(self) -> str:
        """
        Developer-friendly object representation.

        Example:
            User(id=1)
            Note(id=15)
        """
        identity = getattr(self, "id", None)
        return f"{self.__class__.__name__}(id={identity})"