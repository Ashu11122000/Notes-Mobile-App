"""
===============================================================================
File: deps.py
===============================================================================

Authentication & Authorization Dependencies

Responsibilities
-------------------------------------------------------------------------------
- Validate JWT access tokens.
- Retrieve authenticated users.
- Enforce account status.
- Provide Role-Based Access Control (RBAC).
- Keep route handlers clean.

Architecture
-------------------------------------------------------------------------------

Request
   |
Bearer Token
   |
JWT Validation
   |
Current User
   |
Role Validation
   |
Protected Endpoint


Security Flow
-------------------------------------------------------------------------------

Flutter App
    |
    | Authorization: Bearer <JWT>
    |
FastAPI
    |
    | decode_access_token()
    |
JWT Payload
    |
sub = user email
    |
Database User Lookup


Notes
-------------------------------------------------------------------------------
- Compatible with FastAPI dependency injection.
- Uses JWT authentication.
- Supports role-based authorization.
- No business logic inside dependencies.
===============================================================================
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

_AUTH_HEADERS = {
    "WWW-Authenticate": "Bearer",
}


_INVALID_TOKEN = "Invalid or expired access token."

_INVALID_PAYLOAD = "Invalid token payload."

_USER_NOT_FOUND = "User not found."

_USER_INACTIVE = "User account is inactive."

_INSUFFICIENT_PERMISSIONS = "Insufficient permissions."

_ACCESS_DENIED = "Access denied."



# =============================================================================
# OAuth2 Authentication Scheme
# =============================================================================
#
# IMPORTANT:
#
# Your FastAPI route:
#
# POST /api/v1/auth/login
#
# Therefore OAuth2 tokenUrl must match.
#
# =============================================================================


oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="/api/v1/auth/login",
)



# =============================================================================
# Current Authenticated User
# =============================================================================


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    Validate JWT and return authenticated user.

    JWT Payload Expected:

    {
        "sub": "user@email.com",
        "iat": "...",
        "exp": "..."
    }


    Raises:

    401:
        Invalid token.

    404:
        User does not exist.

    403:
        User inactive.
    """

    # -------------------------------------------------------------------------
    # Decode JWT
    # -------------------------------------------------------------------------

    payload = decode_access_token(token)


    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_TOKEN,
            headers=_AUTH_HEADERS,
        )


    # -------------------------------------------------------------------------
    # Extract Subject
    # -------------------------------------------------------------------------
    #
    # IMPORTANT:
    #
    # security.py creates token using:
    #
    # create_access_token(
    #     data={
    #         "sub": user.email
    #     }
    # )
    #
    # -------------------------------------------------------------------------

    subject = payload.get("sub")


    if not isinstance(subject, str) or not subject.strip():

        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=_INVALID_PAYLOAD,
            headers=_AUTH_HEADERS,
        )


    email = subject.strip()



    # -------------------------------------------------------------------------
    # Fetch User
    # -------------------------------------------------------------------------

    user = get_user_by_email(
        db=db,
        email=email,
    )


    if user is None:

        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=_USER_NOT_FOUND,
        )



    # -------------------------------------------------------------------------
    # Check Account Status
    # -------------------------------------------------------------------------

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

    Example:

    current_user = Depends(
        require_role("admin")
    )
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
    Require one of multiple roles.

    Example:

    require_roles(
        [
            "admin",
            "manager",
        ]
    )
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