"""
===============================================================================
File: deps.py
===============================================================================

Authentication & Authorization Dependencies

Responsibilities
----------------------------------------------------------------------------
- Validate JWT access tokens.
- Retrieve the authenticated user.
- Enforce account status.
- Provide Role-Based Access Control (RBAC) dependencies.
- Keep route handlers clean and reusable.

Architecture
----------------------------------------------------------------------------
Request
   │
Bearer Token
   │
JWT Validation
   │
Current User
   │
Role Validation
   │
Protected Endpoint

Notes
----------------------------------------------------------------------------
- Compatible with FastAPI.
- JWT Authentication.
- Supports Single Role Authorization.
- Supports Multiple Role Authorization.
"""

from collections.abc import Callable, Collection

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.user import User
from app.services.user_service import get_user_by_email

__all__ = (
    "oauth2_scheme",
    "get_current_user",
    "require_role",
    "require_roles",
)

# =============================================================================
# Constants
# =============================================================================

_AUTH_HEADERS = {"WWW-Authenticate": "Bearer"}

_INVALID_TOKEN = "Invalid or expired access token."
_INVALID_PAYLOAD = "Invalid token payload."
_USER_NOT_FOUND = "User not found."
_USER_INACTIVE = "User account is inactive."
_INSUFFICIENT_PERMISSIONS = "Insufficient permissions."
_ACCESS_DENIED = "Access denied."

# =============================================================================
# OAuth2 Authentication Scheme
# =============================================================================

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="/auth/login",
)

# =============================================================================
# Current Authenticated User
# =============================================================================


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    Validate the JWT access token and return the authenticated user.

    Raises:
        HTTPException:
            - 401 if the token is invalid or malformed.
            - 404 if the user no longer exists.
            - 403 if the account is inactive.
    """

    payload = decode_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_TOKEN,
            headers=_AUTH_HEADERS,
        )

    email = payload.get("sub")

    if not isinstance(email, str) or not email:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_PAYLOAD,
            headers=_AUTH_HEADERS,
        )

    user = get_user_by_email(
        db=db,
        email=email,
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=_USER_NOT_FOUND,
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=_USER_INACTIVE,
        )

    return user


# =============================================================================
# Single Role Authorization
# =============================================================================


def require_role(
    required_role: str,
) -> Callable[..., User]:
    """
    Require exactly one role.

    Args:
        required_role: Role required to access the endpoint.

    Returns:
        A FastAPI dependency that validates the user's role.
    """

    def role_checker(
        current_user: User = Depends(get_current_user),
    ) -> User:
        if current_user.role != required_role:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=_INSUFFICIENT_PERMISSIONS,
            )

        return current_user

    return role_checker


# =============================================================================
# Multiple Role Authorization
# =============================================================================


def require_roles(
    allowed_roles: Collection[str],
) -> Callable[..., User]:
    """
    Require one of multiple allowed roles.

    Args:
        allowed_roles: Collection of roles permitted to access the endpoint.

    Returns:
        A FastAPI dependency that validates the user's role.
    """

    allowed = frozenset(allowed_roles)

    def role_checker(
        current_user: User = Depends(get_current_user),
    ) -> User:
        if current_user.role not in allowed:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=_ACCESS_DENIED,
            )

        return current_user

    return role_checker