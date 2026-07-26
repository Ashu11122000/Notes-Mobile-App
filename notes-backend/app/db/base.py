"""
===============================================================================
File: base.py
===============================================================================

SQLAlchemy Declarative Base

Responsibilities
----------------------------------------------------------------------------
- Define the application's declarative base class.
- Serve as the parent class for all SQLAlchemy ORM models.
- Provide a centralized metadata registry for database tables.
- Enable SQLAlchemy 2.x Declarative Mapping.
- Act as the single source of metadata for migrations and schema creation.

Usage
----------------------------------------------------------------------------
Example:

    from app.db.base import Base

    class User(Base):
        __tablename__ = "users"

        id = mapped_column(Integer, primary_key=True)

Notes
----------------------------------------------------------------------------
- Compatible with SQLAlchemy 2.x Declarative Mapping.
- All ORM models should inherit from this Base class.
- Alembic and SQLAlchemy use this metadata registry for migrations.
"""

from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """
    Base class for all SQLAlchemy ORM models.

    Every ORM model should inherit from this class to participate
    in SQLAlchemy's declarative mapping system and automatically
    register its table metadata.

    This class intentionally contains no shared columns or behavior.
    Common model functionality should be introduced through dedicated
    mixins when needed to maintain separation of concerns.
    """

    __abstract__ = True
    __slots__ = ()