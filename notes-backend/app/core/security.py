"""
===============================================================================
File: security.py
===============================================================================

Security Utilities

Responsibilities
----------------------------------------------------------------------------
- Password hashing and verification.
- JWT access token generation.
- JWT decoding and validation.
- Centralized security helpers for authentication.

Security
----------------------------------------------------------------------------
- Passwords are hashed using bcrypt via Passlib.
- JWT tokens are signed using the configured secret key.
- Token expiration is configurable through environment variables.
- Compatible with FastAPI dependency injection.

Author
----------------------------------------------------------------------------
Team Productivity Platform
"""

from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

# =============================================================================
# Password Hashing Configuration
# =============================================================================

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)

# =============================================================================
# Password Utilities
# =============================================================================


def hash_password(password: str) -> str:
    """
    Hash a plain-text password.

    Args:
        password: User's plain-text password.

    Returns:
        Secure bcrypt hashed password.
    """

    return pwd_context.hash(password)


def verify_password(
    plain_password: str,
    hashed_password: str,
) -> bool:
    """
    Verify a password against its hash.

    Args:
        plain_password: Password provided by the user.
        hashed_password: Stored hashed password.

    Returns:
        True if the password matches, otherwise False.
    """

    return pwd_context.verify(
        plain_password,
        hashed_password,
    )


# =============================================================================
# JWT Utilities
# =============================================================================


def create_access_token(
    data: dict[str, Any],
    expires_delta: timedelta | None = None,
) -> str:
    """
    Create a signed JWT access token.

    Args:
        data: Payload to encode.
        expires_delta: Optional custom expiration duration.

    Returns:
        Encoded JWT access token.
    """

    payload = data.copy()

    expire = datetime.now(timezone.utc) + (
        expires_delta
        if expires_delta
        else timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )
    )

    payload.update(
        {
            "exp": expire,
        }
    )

    return jwt.encode(
        payload,
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM,
    )


def decode_access_token(
    token: str,
) -> dict[str, Any] | None:
    """
    Decode and validate a JWT access token.

    Args:
        token: JWT access token.

    Returns:
        Decoded payload if valid, otherwise None.
    """

    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM],
        )

        return payload

    except JWTError:
        return None