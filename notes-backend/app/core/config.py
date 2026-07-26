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
- Expose computed configuration values.
- Validate configuration at application startup.
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

from typing import Literal

from pydantic import SecretStr, computed_field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    Global application configuration.

    Configuration values are loaded once during application startup
    and remain immutable throughout the application's lifetime.
    """

    # =========================================================================
    # Application
    # =========================================================================

    APP_NAME: str = "Notes Backend"
    ENVIRONMENT: Literal["development", "testing", "staging", "production"] = (
        "development"
    )
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

    SECRET_KEY: SecretStr
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # =========================================================================
    # Pydantic Configuration
    # =========================================================================

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
        frozen=True,
    )

    # =========================================================================
    # Validators
    # =========================================================================

    @field_validator("PORT")
    @classmethod
    def validate_port(cls, value: int) -> int:
        """
        Ensure the server port is within the valid TCP range.
        """
        if not 1 <= value <= 65535:
            raise ValueError("PORT must be between 1 and 65535.")
        return value

    @field_validator("ACCESS_TOKEN_EXPIRE_MINUTES")
    @classmethod
    def validate_token_expiry(cls, value: int) -> int:
        """
        Ensure JWT expiration time is positive.
        """
        if value <= 0:
            raise ValueError("ACCESS_TOKEN_EXPIRE_MINUTES must be greater than 0.")
        return value

    # =========================================================================
    # Computed Properties
    # =========================================================================

    @computed_field
    @property
    def DATABASE_URL(self) -> str:
        """
        SQLAlchemy database connection URL.
        """
        return (
            "postgresql+psycopg2://"
            f"{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
        )

    @computed_field
    @property
    def IS_DEVELOPMENT(self) -> bool:
        """
        Indicates whether the application is running in
        the development environment.
        """
        return self.ENVIRONMENT == "development"

    @computed_field
    @property
    def IS_PRODUCTION(self) -> bool:
        """
        Indicates whether the application is running in
        the production environment.
        """
        return self.ENVIRONMENT == "production"


# =============================================================================
# Singleton Settings Instance
# =============================================================================

settings = Settings()