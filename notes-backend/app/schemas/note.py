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

from pydantic import BaseModel, ConfigDict, Field


# =============================================================================
# Base Schema
# =============================================================================


class NoteBase(BaseModel):
    """
    Base schema shared by all note models.
    """

    title: str = Field(
        ...,
        min_length=1,
        max_length=255,
        description="Title of the note.",
        examples=["Shopping List"],
    )

    content: str | None = Field(
        default=None,
        description="Content/body of the note.",
        examples=["Buy milk, bread and eggs."],
    )


# =============================================================================
# Create Schema
# =============================================================================


class NoteCreate(NoteBase):
    """
    Schema used when creating a new note.
    """

    pass


# =============================================================================
# Full Update Schema (PUT)
# =============================================================================


class NoteUpdate(BaseModel):
    """
    Schema used for updating an existing note.

    Supports both PUT and PATCH operations.
    When used with PATCH, call:

        note_update.model_dump(exclude_unset=True)

    so only provided fields are updated.
    """

    title: str | None = Field(
        default=None,
        min_length=1,
        max_length=255,
        description="Updated title.",
    )

    content: str | None = Field(
        default=None,
        description="Updated note content.",
    )


# =============================================================================
# Response Schema
# =============================================================================


class NoteResponse(NoteBase):
    """
    Response returned after reading or creating a note.
    """

    id: int
    owner_id: int
    created_at: datetime
    updated_at: datetime | None

    model_config = ConfigDict(
        from_attributes=True
    )