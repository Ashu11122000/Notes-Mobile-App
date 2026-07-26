"""
===============================================================================
File: user.py
===============================================================================

User Schemas

Responsibilities
----------------------------------------------------------------------------
- Define request and response schemas for user authentication.
- Validate incoming user data.
- Serialize ORM models into API responses.
- Provide automatic OpenAPI (Swagger) documentation.

Notes
----------------------------------------------------------------------------
- Compatible with Pydantic V2.
- Used by FastAPI request validation.
- Used for authentication endpoints.
"""

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

_PASSWORD_MIN_LENGTH = 8
_PASSWORD_MAX_LENGTH = 128


# =============================================================================
# Base Authentication Schema
# =============================================================================


class UserAuthBase(BaseModel):
    """
    Shared authentication schema used for user registration
    and login requests.
    """

    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    email: EmailStr = Field(
        ...,
        description="User email address.",
        examples=["ashish@example.com"],
    )

    password: str = Field(
        ...,
        min_length=_PASSWORD_MIN_LENGTH,
        max_length=_PASSWORD_MAX_LENGTH,
        description="User password.",
        examples=["Password@123"],
    )

    @field_validator("password")
    @classmethod
    def validate_password(cls, value: str) -> str:
        """
        Ensure the password is not empty after trimming
        whitespace.
        """

        if not value.strip():
            raise ValueError("Password cannot be empty.")

        return value


# =============================================================================
# User Registration Schema
# =============================================================================


class UserCreate(UserAuthBase):
    """
    Schema used to register a new user.
    """

    password: str = Field(
        ...,
        min_length=_PASSWORD_MIN_LENGTH,
        max_length=_PASSWORD_MAX_LENGTH,
        description="User password (minimum 8 characters).",
        examples=["Password@123"],
    )


# =============================================================================
# User Login Schema
# =============================================================================


class UserLogin(UserAuthBase):
    """
    Schema used for user login.
    """

    password: str = Field(
        ...,
        min_length=_PASSWORD_MIN_LENGTH,
        max_length=_PASSWORD_MAX_LENGTH,
        description="Registered user password.",
        examples=["Password@123"],
    )


# =============================================================================
# User Response Schema
# =============================================================================


class UserResponse(BaseModel):
    """
    Response returned after successful authentication
    or when fetching the authenticated user.
    """

    model_config = ConfigDict(
        from_attributes=True,
        validate_assignment=True,
    )

    id: int = Field(
        description="Unique identifier of the user.",
        examples=[1],
    )

    email: EmailStr = Field(
        description="Registered email address.",
        examples=["ashish@example.com"],
    )

    role: str = Field(
        description="Role assigned to the user.",
        examples=["user"],
    )

    is_active: bool = Field(
        description="Indicates whether the user account is active.",
        examples=[True],
    )