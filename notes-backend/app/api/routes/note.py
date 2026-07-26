"""
===============================================================================
File: note.py
===============================================================================

Notes Controller

Responsibilities
----------------------------------------------------------------------------
- Expose REST endpoints for Notes.
- Validate incoming request DTOs.
- Delegate business logic to NotesService.
- Return response DTOs only.
- Never access the database directly.

Architecture
----------------------------------------------------------------------------
Client
    │
    ▼
Notes Controller
    │
    ▼
Notes Service
    │
    ▼
PostgreSQL

Notes
----------------------------------------------------------------------------
- JWT Protected.
- Supports Pagination.
- Supports PUT (Full Update).
- Supports PATCH (Partial Update).
- Compatible with FastAPI + SQLAlchemy 2.x.
"""

from typing import Annotated

from fastapi import APIRouter, Depends, Path, Query, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.note import (
    NoteCreate,
    NoteResponse,
    NoteUpdate,
)
from app.services import note_service

__all__ = ("router",)

# =============================================================================
# Constants
# =============================================================================

_DEFAULT_PAGE = 1
_DEFAULT_LIMIT = 10
_MAX_LIMIT = 100

# =============================================================================
# Dependency Aliases
# =============================================================================

DBSession = Annotated[Session, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]

# =============================================================================
# Router
# =============================================================================

router = APIRouter(
    prefix="/notes",
    tags=["Notes"],
)

# =============================================================================
# Create Note
# =============================================================================


@router.post(
    "",
    response_model=NoteResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create Note",
    description="Create a new note for the authenticated user.",
)
def create_note(
    note: NoteCreate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    """
    Create a new note for the authenticated user.
    """

    return note_service.create_note(
        db=db,
        user_id=current_user.id,
        note=note,
    )


# =============================================================================
# Get Notes (Pagination)
# =============================================================================


@router.get(
    "",
    response_model=list[NoteResponse],
    summary="Get Notes",
    description="Retrieve paginated notes belonging to the authenticated user.",
)
def get_notes(
    page: Annotated[
        int,
        Query(
            ge=1,
            description="Page number (starting from 1).",
        ),
    ] = _DEFAULT_PAGE,
    limit: Annotated[
        int,
        Query(
            ge=1,
            le=_MAX_LIMIT,
            description="Maximum number of notes per page.",
        ),
    ] = _DEFAULT_LIMIT,
    db: DBSession = None,
    current_user: CurrentUser = None,
) -> list[NoteResponse]:
    """
    Retrieve paginated notes for the authenticated user.
    """

    skip = (page - 1) * limit

    return note_service.get_notes(
        db=db,
        user_id=current_user.id,
        skip=skip,
        limit=limit,
    )


# =============================================================================
# Get Note By ID
# =============================================================================


@router.get(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Get Note",
    description="Retrieve a note by its ID.",
)
def get_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Unique identifier of the note.",
        ),
    ],
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    """
    Retrieve a single note.
    """

    return note_service.get_note_by_id(
        db=db,
        current_user=current_user,
        note_id=note_id,
    )


# =============================================================================
# Full Update (PUT)
# =============================================================================


@router.put(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Replace Note",
    description="Replace or update a note.",
)
def update_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Unique identifier of the note.",
        ),
    ],
    note_data: NoteUpdate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    """
    Fully update a note.
    """

    return note_service.update_note(
        db=db,
        current_user=current_user,
        note_id=note_id,
        note_data=note_data,
    )


# =============================================================================
# Partial Update (PATCH)
# =============================================================================


@router.patch(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Partially Update Note",
    description="Update only the supplied fields of a note.",
)
def patch_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Unique identifier of the note.",
        ),
    ],
    note_data: NoteUpdate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    """
    Partially update a note.
    """

    return note_service.update_note(
        db=db,
        current_user=current_user,
        note_id=note_id,
        note_data=note_data,
    )


# =============================================================================
# Delete Note
# =============================================================================


@router.delete(
    "/{note_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete Note",
    description="Delete a note owned by the authenticated user.",
)
def delete_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Unique identifier of the note.",
        ),
    ],
    db: DBSession,
    current_user: CurrentUser,
) -> None:
    """
    Delete a note.
    """

    note_service.delete_note(
        db=db,
        current_user=current_user,
        note_id=note_id,
    )

    return None