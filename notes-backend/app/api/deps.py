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

from collections.abc import Callable

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.user import User
from app.services.user_service import get_user_by_email

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
    Validate JWT token and return the authenticated user.
    """

    payload = decode_access_token(token)

    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired access token.",
        )

    email = payload.get("sub")

    if not email:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload.",
        )

    user = get_user_by_email(
        db=db,
        email=email,
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found.",
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive.",
        )

    return user


# =============================================================================
# Single Role Authorization
# =============================================================================


def require_role(
    required_role: str,
) -> Callable:
    """
    Require exactly one role.
    """

    def role_checker(
        current_user: User = Depends(get_current_user),
    ) -> User:
        if current_user.role != required_role:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions.",
            )

        return current_user

    return role_checker


# =============================================================================
# Multiple Role Authorization
# =============================================================================


def require_roles(
    allowed_roles: list[str],
) -> Callable:
    """
    Require one of multiple allowed roles.
    """

    def role_checker(
        current_user: User = Depends(get_current_user),
    ) -> User:
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied.",
            )

        return current_user

    return role_checker