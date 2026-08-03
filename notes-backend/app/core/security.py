"""
===============================================================================
File: security.py
===============================================================================
Enterprise Security Utilities

- Password hashing
- Password verification
- JWT creation
- JWT validation
- Authentication helpers

Compatible with:
- FastAPI
- SQLAlchemy
- python-jose
- pwdlib
===============================================================================
"""

from __future__ import annotations

from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt
from pwdlib import PasswordHash

from app.core.config import settings

__all__ = (
    "hash_password",
    "verify_password",
    "create_access_token",
    "decode_access_token",
    "extract_subject",
)

# =============================================================================
# Password Hashing
# =============================================================================

password_hash = PasswordHash.recommended()

# =============================================================================
# JWT Configuration
# =============================================================================

_SECRET_KEY = settings.SECRET_KEY.get_secret_value()
_ALGORITHM = settings.ALGORITHM

_DEFAULT_EXPIRY = timedelta(
    minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES,
)

# =============================================================================
# Password Helpers
# =============================================================================


def hash_password(password: str) -> str:
    """
    Hash a plain-text password.
    """

    if not password:
        raise ValueError("Password cannot be empty.")

    return password_hash.hash(password)


def verify_password(
    plain_password: str,
    hashed_password: str,
) -> bool:
    """
    Verify a plain password against a stored hash.
    """

    if not plain_password or not hashed_password:
        return False

    return password_hash.verify(
        plain_password,
        hashed_password,
    )


# =============================================================================
# JWT Helpers
# =============================================================================


def create_access_token(
    data: dict[str, Any],
    expires_delta: timedelta | None = None,
) -> str:
    """
    Create a signed JWT access token.
    """

    now = datetime.now(timezone.utc)

    payload = data.copy()

    payload.update(
        {
            "iat": now,
            "nbf": now,
            "exp": now + (expires_delta or _DEFAULT_EXPIRY),
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
    Decode and validate a JWT.
    """

    try:
        payload = jwt.decode(
            token,
            _SECRET_KEY,
            algorithms=[_ALGORITHM],
            options={
                "verify_signature": True,
                "verify_exp": True,
                "verify_iat": True,
                "verify_nbf": True,
            },
        )

        if "sub" not in payload:
            return None

        return payload

    except JWTError:
        return None


def extract_subject(token: str) -> str | None:
    """
    Extract the subject (user id/email) from a JWT.
    """

    payload = decode_access_token(token)

    if payload is None:
        return None

    subject = payload.get("sub")

    if not isinstance(subject, str):
        return None

    return subject