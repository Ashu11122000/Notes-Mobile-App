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
- Uses UTC timestamps and standard JWT claims.

Author
----------------------------------------------------------------------------
Team Productivity Platform
"""

from datetime import datetime, timedelta, timezone
from typing import Any, Mapping

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

__all__ = (
    "hash_password",
    "verify_password",
    "create_access_token",
    "decode_access_token",
)

# =============================================================================
# Password Hashing Configuration
# =============================================================================

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)

# =============================================================================
# JWT Configuration
# =============================================================================

_SECRET_KEY = settings.SECRET_KEY.get_secret_value()
_ALGORITHM = settings.ALGORITHM
_DEFAULT_TOKEN_EXPIRY = timedelta(
    minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES,
)

# =============================================================================
# Password Utilities
# =============================================================================


def hash_password(password: str) -> str:
    """
    Hash a plain-text password using bcrypt.

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
    Verify a plain-text password against a bcrypt hash.

    Args:
        plain_password: Password provided by the user.
        hashed_password: Stored bcrypt hash.

    Returns:
        True if the password is valid; otherwise False.
    """

    return pwd_context.verify(
        plain_password,
        hashed_password,
    )


# =============================================================================
# JWT Utilities
# =============================================================================


def create_access_token(
    data: Mapping[str, Any],
    expires_delta: timedelta | None = None,
) -> str:
    """
    Create a signed JWT access token.

    Args:
        data: Claims to include in the token payload.
        expires_delta: Optional custom token lifetime.

    Returns:
        Encoded JWT access token.
    """

    now = datetime.now(timezone.utc)
    expire = now + (expires_delta or _DEFAULT_TOKEN_EXPIRY)

    payload = dict(data)
    payload.update(
        {
            "iat": now,
            "nbf": now,
            "exp": expire,
        }
    )

    return jwt.encode(
        payload,
        _SECRET_KEY,
        algorithm=_ALGORITHM,
    )


def decode_access_token(
    token: str,
) -> dict[str, Any] | None:
    """
    Decode and validate a JWT access token.

    Args:
        token: Encoded JWT access token.

    Returns:
        The decoded JWT payload if the token is valid;
        otherwise None.
    """

    try:
        return jwt.decode(
            token,
            _SECRET_KEY,
            algorithms=[_ALGORITHM],
        )

    except JWTError:
        return None