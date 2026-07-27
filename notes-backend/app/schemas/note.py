from __future__ import annotations

"""
===============================================================================
File: note.py
===============================================================================

Enterprise Note Schemas

Responsibilities
-------------------------------------------------------------------------------
- Request validation
- Response serialization
- OpenAPI documentation
- Create / Update / Response models
- Pydantic V2 compatible

Compatible With
-------------------------------------------------------------------------------
- FastAPI
- SQLAlchemy 2.x
- Pydantic V2
===============================================================================
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

TITLE_MIN_LENGTH = 1
TITLE_MAX_LENGTH = 255

CONTENT_MAX_LENGTH = 50_000


# =============================================================================
# Base Schema
# =============================================================================


class NoteBase(BaseModel):
    """
    Shared note schema.
    """

    model_config = ConfigDict(
        from_attributes=True,
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    title: str = Field(
        min_length=TITLE_MIN_LENGTH,
        max_length=TITLE_MAX_LENGTH,
        description="Title of the note.",
        examples=["Shopping List"],
    )

    content: str | None = Field(
        default=None,
        max_length=CONTENT_MAX_LENGTH,
        description="Content of the note.",
        examples=["Buy milk, eggs and bread."],
    )

    @field_validator("title")
    @classmethod
    def validate_title(cls, value: str) -> str:
        """
        Validate note title.
        """

        title = value.strip()

        if not title:
            raise ValueError("Title cannot be empty.")

        return title

    @field_validator("content")
    @classmethod
    def validate_content(cls, value: str | None) -> str | None:
        """
        Normalize note content.
        """

        if value is None:
            return None

        content = value.strip()

        return content or None


# =============================================================================
# Create
# =============================================================================


class NoteCreate(NoteBase):
    """
    Create note request.
    """

    pass


# =============================================================================
# Update
# =============================================================================


class NoteUpdate(BaseModel):
    """
    Update note request.

    Supports PUT and PATCH.

    For PATCH use:

        model_dump(exclude_unset=True)
    """

    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        extra="forbid",
    )

    title: str | None = Field(
        default=None,
        min_length=TITLE_MIN_LENGTH,
        max_length=TITLE_MAX_LENGTH,
        description="Updated title.",
        examples=["Meeting Notes"],
    )

    content: str | None = Field(
        default=None,
        max_length=CONTENT_MAX_LENGTH,
        description="Updated content.",
        examples=["Discuss quarterly roadmap."],
    )

    @field_validator("title")
    @classmethod
    def validate_title(
        cls,
        value: str | None,
    ) -> str | None:

        if value is None:
            return None

        title = value.strip()

        if not title:
            raise ValueError("Title cannot be empty.")

        return title

    @field_validator("content")
    @classmethod
    def validate_content(
        cls,
        value: str | None,
    ) -> str |None:

        if value is None:
            return None

        content = value.strip()

        return content or None


# =============================================================================
# Response
# =============================================================================


class NoteResponse(NoteBase):
    """
    Public note response.
    """

    id: int = Field(
        description="Note identifier.",
        examples=[1],
    )

    owner_id: int = Field(
        description="Owner identifier.",
        examples=[5],
    )

    created_at: datetime = Field(
        description="Creation timestamp (UTC).",
    )

    updated_at: datetime = Field(
        description="Last update timestamp (UTC).",
    )