"""
===============================================================================
File: alembic/env.py
===============================================================================

Alembic Environment Configuration

Responsibilities
-------------------------------------------------------------------------------
- Configure Alembic migrations.
- Load application settings.
- Register SQLAlchemy metadata.
- Support offline and online migrations.
- Integrate with SQLAlchemy 2.x.

Compatible With
-------------------------------------------------------------------------------
- FastAPI
- SQLAlchemy 2.x
- PostgreSQL
- Alembic
===============================================================================
"""

from __future__ import annotations

from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool

from app.core.config import settings
from app.db.base import Base

# Import all models so Alembic can detect them.
import app.models.note  # noqa: F401
import app.models.user  # noqa: F401

# =============================================================================
# Alembic Configuration
# =============================================================================

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Override database URL from application settings
config.set_main_option(
    "sqlalchemy.url",
    settings.DATABASE_URL,
)

# Metadata used for autogenerate
target_metadata = Base.metadata


# =============================================================================
# Offline Migrations
# =============================================================================

def run_migrations_offline() -> None:
    """
    Run migrations without a live database connection.
    """

    context.configure(
        url=settings.DATABASE_URL,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={
            "paramstyle": "named",
        },
        compare_type=True,
        compare_server_default=True,
    )

    with context.begin_transaction():
        context.run_migrations()


# =============================================================================
# Online Migrations
# =============================================================================

def run_migrations_online() -> None:
    """
    Run migrations using a live database connection.
    """

    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
        future=True,
    )

    with connectable.connect() as connection:

        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
        )

        with context.begin_transaction():
            context.run_migrations()


# =============================================================================
# Entry Point
# =============================================================================

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()