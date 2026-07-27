from __future__ import annotations

"""
===============================================================================
File: user.py
===============================================================================

Enterprise User Schemas

Responsibilities
-------------------------------------------------------------------------------
- Request validation
- Response serialization
- OpenAPI documentation
- Authentication schema definitions
- Pydantic V2 compatible

Compatible With
-------------------------------------------------------------------------------
- FastAPI
- Pydantic V2
===============================================================================
"""

import re

from pydantic import (
    BaseModel,
    ConfigDict,
    EmailStr,
    Field,
    field_validator,
)

__all__ = (
    "UserCreate",
    "UserLogin",
    "UserResponse",
)

# =============================================================================
# Constants
# =============================================================================

PASSWORD_MIN_LENGTH = 8
PASSWORD_MAX_LENGTH = 128

PASSWORD_REGEX = re.compile(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$"
)


# =============================================================================
# Base Authentication Schema
# =============================================================================


class UserAuthBase(BaseModel):
    """
    Shared authentication schema.
    """

    model_config = ConfigDict(
        from_attributes=True,
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    email: EmailStr = Field(
        description="Registered email address.",
        examples=["ashish@example.com"],
    )

    password: str = Field(
        min_length=PASSWORD_MIN_LENGTH,
        max_length=PASSWORD_MAX_LENGTH,
        description="User password.",
        examples=["Password@123"],
    )

    @field_validator("password")
    @classmethod
    def validate_password(cls, value: str) -> str:
        """
        Validate password quality.
        """

        password = value.strip()

        if not password:
            raise ValueError("Password cannot be empty.")

        if not PASSWORD_REGEX.match(password):
            raise ValueError(
                "Password must contain at least one uppercase letter, "
                "one lowercase letter, and one digit."
            )

        return password


# =============================================================================
# Registration
# =============================================================================


class UserCreate(UserAuthBase):
    """
    User registration request.
    """

    pass


# =============================================================================
# Login
# =============================================================================


class UserLogin(UserAuthBase):
    """
    User login request.
    """

    pass


# =============================================================================
# Response
# =============================================================================


class UserResponse(BaseModel):
    """
    Public user response.
    """

    model_config = ConfigDict(
        from_attributes=True,
        validate_assignment=True,
        extra="ignore",
    )

    id: int = Field(
        description="User identifier.",
        examples=[1],
    )

    email: EmailStr = Field(
        description="Registered email.",
        examples=["ashish@example.com"],
    )

    role: str = Field(
        description="Assigned role.",
        examples=["user"],
    )

    is_active: bool = Field(
        description="Account status.",
        examples=[True],
    )