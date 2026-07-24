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
- Used by SQLAlchemy to create and manage database schemas.

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
"""

from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    """
    Base class for all SQLAlchemy ORM models.

    Every database model in the application should inherit from
    this class to automatically register its table metadata.
    """

    pass