"""
===============================================================================
File: config.py
===============================================================================

Application Configuration

Responsibilities
----------------------------------------------------------------------------
- Load environment variables from the .env file.
- Provide strongly typed application settings.
- Centralize all configuration values.
- Expose computed configuration values when required.
- Ensure compatibility with Pydantic V2.

Environment
----------------------------------------------------------------------------
Configuration is automatically loaded from:

    .env

Example:

    APP_NAME=Notes Backend
    DEBUG=True

    HOST=127.0.0.1
    PORT=8000

    DB_HOST=localhost
    DB_PORT=5434
    DB_NAME=notes_db
    DB_USER=postgres
    DB_PASSWORD=postgres

    SECRET_KEY=supersecretkey
    ALGORITHM=HS256
    ACCESS_TOKEN_EXPIRE_MINUTES=30
"""

from pydantic import computed_field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Global application configuration.

    All values are automatically loaded from the .env file.
    """

    # =========================================================================
    # Application
    # =========================================================================

    APP_NAME: str = "Notes Backend"
    ENVIRONMENT: str = "development"
    DEBUG: bool = False

    # =========================================================================
    # Server
    # =========================================================================

    HOST: str = "127.0.0.1"
    PORT: int = 8000

    # =========================================================================
    # PostgreSQL Database
    # =========================================================================

    DB_HOST: str
    DB_PORT: int
    DB_NAME: str
    DB_USER: str
    DB_PASSWORD: str

    # =========================================================================
    # JWT Authentication
    # =========================================================================

    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # =========================================================================
    # Pydantic Configuration
    # =========================================================================

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
        case_sensitive=True,
    )

    # =========================================================================
    # Computed Properties
    # =========================================================================

    @computed_field
    @property
    def DATABASE_URL(self) -> str:
        """
        Returns the SQLAlchemy database connection URL.
        """

        return (
            f"postgresql+psycopg2://"
            f"{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
        )


# =============================================================================
# Singleton Settings Instance
# =============================================================================

settings = Settings()