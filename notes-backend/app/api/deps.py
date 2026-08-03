from __future__ import annotations

from collections.abc import Callable, Collection
from typing import TypeAlias

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.core.security import extract_subject
from app.db.session import get_db
from app.models.user import ROLE_ADMIN, User
from app.services.user_service import get_user_by_email

AuthDependency: TypeAlias = Callable[..., User]

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="/api/v1/auth/login",
)

_AUTH_HEADERS = {
    "WWW-Authenticate": "Bearer",
}


def unauthorized(detail: str) -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=detail,
        headers=_AUTH_HEADERS,
    )


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:

    email = extract_subject(token)

    if email is None:
        raise unauthorized("Invalid or expired access token.")

    user = get_user_by_email(
        db=db,
        email=email,
    )

    if user is None:
        raise HTTPException(
            status_code=404,
            detail="User not found.",
        )

    if not user.is_active:
        raise HTTPException(
            status_code=403,
            detail="User account is inactive.",
        )

    return user


def require_role(
    required_role: str,
) -> AuthDependency:

    required = required_role.strip().lower()

    def checker(
        current_user: User = Depends(get_current_user),
    ) -> User:

        if current_user.role != required:
            raise HTTPException(
                status_code=403,
                detail="Insufficient permissions.",
            )

        return current_user

    return checker


def require_roles(
    allowed_roles: Collection[str],
) -> AuthDependency:

    allowed = frozenset(
        role.strip().lower()
        for role in allowed_roles
    )

    def checker(
        current_user: User = Depends(get_current_user),
    ) -> User:

        if current_user.role not in allowed:
            raise HTTPException(
                status_code=403,
                detail="Access denied.",
            )

        return current_user

    return checker