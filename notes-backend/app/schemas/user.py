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
- Used for Authentication endpoints.
"""

from pydantic import BaseModel, ConfigDict, EmailStr, Field

# =============================================================================
# User Registration Schema
# =============================================================================


class UserCreate(BaseModel):
    """
    Schema used to register a new user.
    """

    email: EmailStr = Field(
        ...,
        description="User email address.",
        examples=["ashish@example.com"],
    )

    password: str = Field(
        ...,
        min_length=8,
        max_length=128,
        description="User password (minimum 8 characters).",
        examples=["Password@123"],
    )


# =============================================================================
# User Login Schema
# =============================================================================


class UserLogin(BaseModel):
    """
    Schema used for user login.
    """

    email: EmailStr = Field(
        ...,
        description="Registered email address.",
        examples=["ashish@example.com"],
    )

    password: str = Field(
        ...,
        min_length=8,
        max_length=128,
        description="User password.",
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

    id: int

    email: EmailStr

    role: str

    is_active: bool

    model_config = ConfigDict(
        from_attributes=True
    )