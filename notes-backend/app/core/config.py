"""
===============================================================================
File: app/core/config.py
===============================================================================

Enterprise Application Configuration

Responsibilities
-------------------------------------------------------------------------------
- Load environment variables.
- Provide strongly typed application settings.
- Validate configuration at startup.
- Build computed values (database URL, environment helpers).
- Centralize all runtime configuration.
===============================================================================
"""

from __future__ import annotations

from typing import Literal

from pydantic import (
    SecretStr,
    PostgresDsn,
    computed_field,
    field_validator,
)
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # ==========================================================================
    # Application
    # ==========================================================================

    APP_NAME: str = "Notes Backend"
    APP_VERSION: str = "1.0.0"

    ENVIRONMENT: Literal[
        "development",
        "testing",
        "staging",
        "production",
    ] = "development"

    DEBUG: bool = False

    # ==========================================================================
    # Server
    # ==========================================================================

    HOST: str = "127.0.0.1"
    PORT: int = 8000

    # ==========================================================================
    # Database
    # ==========================================================================

    DB_HOST: str
    DB_PORT: int
    DB_NAME: str
    DB_USER: str
    DB_PASSWORD: SecretStr

    # Connection Pool
    DB_POOL_SIZE: int = 5
    DB_MAX_OVERFLOW: int = 2
    DB_POOL_TIMEOUT: int = 30
    DB_POOL_RECYCLE: int = 1800
    DB_POOL_PRE_PING: bool = True

    # ==========================================================================
    # JWT
    # ==========================================================================

    SECRET_KEY: SecretStr

    ALGORITHM: str = "HS256"

    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # ==========================================================================
    # Logging
    # ==========================================================================

    LOG_LEVEL: Literal[
        "DEBUG",
        "INFO",
        "WARNING",
        "ERROR",
        "CRITICAL",
    ] = "INFO"

    # ==========================================================================
    # Pagination
    # ==========================================================================

    DEFAULT_PAGE_SIZE: int = 10
    MAX_PAGE_SIZE: int = 100

    # ==========================================================================
    # CORS
    # ==========================================================================

    BACKEND_CORS_ORIGINS: list[str] = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ]

    # ==========================================================================
    # Pydantic Settings
    # ==========================================================================

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
        case_sensitive=True,
        frozen=True,
    )

    # ==========================================================================
    # Validators
    # ==========================================================================

    @field_validator("PORT", "DB_PORT")
    @classmethod
    def validate_port(cls, value: int) -> int:
        if not 1 <= value <= 65535:
            raise ValueError("Port must be between 1 and 65535.")
        return value

    @field_validator("ACCESS_TOKEN_EXPIRE_MINUTES")
    @classmethod
    def validate_token_expiry(cls, value: int) -> int:
        if value <= 0:
            raise ValueError(
                "ACCESS_TOKEN_EXPIRE_MINUTES must be greater than zero."
            )
        return value

    @field_validator("DB_POOL_SIZE")
    @classmethod
    def validate_pool_size(cls, value: int) -> int:
        if value < 1:
            raise ValueError("DB_POOL_SIZE must be at least 1.")
        return value

    @field_validator("DB_MAX_OVERFLOW")
    @classmethod
    def validate_overflow(cls, value: int) -> int:
        if value < 0:
            raise ValueError("DB_MAX_OVERFLOW cannot be negative.")
        return value

    # ==========================================================================
    # Computed Fields
    # ==========================================================================

    @computed_field
    @property
    def DATABASE_URL(self) -> str:
        """
        SQLAlchemy PostgreSQL connection URL.
        """

        return str(
            PostgresDsn.build(
                scheme="postgresql+psycopg2",
                username=self.DB_USER,
                password=self.DB_PASSWORD.get_secret_value(),
                host=self.DB_HOST,
                port=self.DB_PORT,
                path=self.DB_NAME,
            )
        )

    @computed_field
    @property
    def IS_DEVELOPMENT(self) -> bool:
        return self.ENVIRONMENT == "development"

    @computed_field
    @property
    def IS_PRODUCTION(self) -> bool:
        return self.ENVIRONMENT == "production"

    @computed_field
    @property
    def IS_TESTING(self) -> bool:
        return self.ENVIRONMENT == "testing"


settings = Settings()