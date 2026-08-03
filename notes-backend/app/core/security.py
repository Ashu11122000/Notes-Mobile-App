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
- Detailed JWT diagnostics (development only).

Compatible with:
- FastAPI
- python-jose
- pwdlib
===============================================================================
"""

from datetime import datetime, timedelta, timezone
from typing import Any, Mapping

from jose import JWTError, jwt
from pwdlib import PasswordHash

from app.core.config import settings

__all__ = (
    "hash_password",
    "verify_password",
    "create_access_token",
    "decode_access_token",
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

_DEFAULT_TOKEN_EXPIRY = timedelta(
    minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES,
)

# =============================================================================
# Password Helpers
# =============================================================================


def hash_password(password: str) -> str:
    """Hash a plain-text password."""

    if not password:
        raise ValueError("Password cannot be empty.")

    return password_hash.hash(password)


def verify_password(
    plain_password: str,
    hashed_password: str,
) -> bool:
    """Verify a password."""

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
    data: Mapping[str, Any],
    expires_delta: timedelta | None = None,
) -> str:
    """
    Create a signed JWT access token.
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

    token = jwt.encode(
        payload,
        _SECRET_KEY,
        algorithm=_ALGORITHM,
    )

    # -------------------------------------------------------------------------
    # Development diagnostics
    # -------------------------------------------------------------------------

    if settings.DEBUG:
        print("\n================ JWT CREATED ================")
        print("Algorithm :", _ALGORITHM)
        print("Expires   :", expire.isoformat())
        print("Claims    :", payload)
        print("Token     :", token)
        print("=============================================\n")

    return token


def decode_access_token(
    token: str,
) -> dict[str, Any] | None:
    """
    Decode and validate a JWT access token.

    Returns:
        Decoded payload if valid, otherwise None.
    """

    if settings.DEBUG:
        print("\n================ JWT DECODE =================")
        print("Algorithm :", _ALGORITHM)
        print("Secret Len:", len(_SECRET_KEY))
        print("Token     :", token)

    try:
        payload = jwt.decode(
            token,
            _SECRET_KEY,
            algorithms=[_ALGORITHM],
        )

        if settings.DEBUG:
            print("Status    : SUCCESS")
            print("Payload   :", payload)
            print("=============================================\n")

        return payload

    except JWTError as exception:
        if settings.DEBUG:
            print("Status    : FAILED")
            print("Error     :", repr(exception))
            print("=============================================\n")

        return None

    except Exception as exception:
        if settings.DEBUG:
            print("Status    : FAILED")
            print("Unexpected:", repr(exception))
            print("=============================================\n")

        return None