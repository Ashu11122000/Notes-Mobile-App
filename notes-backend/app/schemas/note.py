"""
===============================================================================
File: note.py
===============================================================================

Note Schemas

Responsibilities
----------------------------------------------------------------------------
- Define request and response models for Notes.
- Validate incoming API payloads.
- Serialize database models into API responses.
- Provide OpenAPI documentation for Swagger UI.
- Support Create, Update, Partial Update and Response models.

Notes
----------------------------------------------------------------------------
- Compatible with Pydantic V2.
- Used by FastAPI request validation.
- Used by FastAPI automatic documentation.
"""

from datetime import datetime

from pydantic import (
    BaseModel,
    ConfigDict,
    Field,
    field_validator,
)

__all__ = (
    "NoteBase",
    "NoteCreate",
    "NoteUpdate",
    "NoteResponse",
)

# =============================================================================
# Constants
# =============================================================================

_TITLE_MIN_LENGTH = 1
_TITLE_MAX_LENGTH = 255


# =============================================================================
# Base Schema
# =============================================================================


class NoteBase(BaseModel):
    """
    Base schema shared by all note models.
    """

    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    title: str = Field(
        ...,
        min_length=_TITLE_MIN_LENGTH,
        max_length=_TITLE_MAX_LENGTH,
        description="Title of the note.",
        examples=["Shopping List"],
    )

    content: str | None = Field(
        default=None,
        description="Content/body of the note.",
        examples=["Buy milk, bread and eggs."],
    )

    @field_validator("title")
    @classmethod
    def validate_title(cls, value: str) -> str:
        """
        Ensure the title is not empty after trimming whitespace.
        """

        if not value.strip():
            raise ValueError("Title cannot be empty.")

        return value


# =============================================================================
# Create Schema
# =============================================================================


class NoteCreate(NoteBase):
    """
    Schema used when creating a new note.
    """

    pass


# =============================================================================
# Update Schema (PUT / PATCH)
# =============================================================================


class NoteUpdate(BaseModel):
    """
    Schema used for updating an existing note.

    Supports both PUT and PATCH operations.

    For PATCH requests, use:

        model_dump(exclude_unset=True)

    so that only explicitly supplied fields are updated.
    """

    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    title: str | None = Field(
        default=None,
        min_length=_TITLE_MIN_LENGTH,
        max_length=_TITLE_MAX_LENGTH,
        description="Updated note title.",
        examples=["Work Tasks"],
    )

    content: str | None = Field(
        default=None,
        description="Updated note content.",
        examples=["Finish quarterly report."],
    )

    @field_validator("title")
    @classmethod
    def validate_title(
        cls,
        value: str | None,
    ) -> str | None:
        """
        Validate title only when it is supplied.
        """

        if value is None:
            return value

        if not value.strip():
            raise ValueError("Title cannot be empty.")

        return value


# =============================================================================
# Response Schema
# =============================================================================


class NoteResponse(NoteBase):
    """
    Response model returned by the Notes API.
    """

    id: int = Field(
        description="Unique identifier of the note.",
        examples=[1],
    )

    owner_id: int = Field(
        description="Identifier of the note owner.",
        examples=[5],
    )

    created_at: datetime = Field(
        description="UTC timestamp when the note was created.",
    )

    updated_at: datetime | None = Field(
        default=None,
        description="UTC timestamp of the last update.",
    )

    model_config = ConfigDict(
        from_attributes=True,
        str_strip_whitespace=True,
    )