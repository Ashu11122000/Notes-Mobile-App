"""
===============================================================================
File: note_service.py
===============================================================================

Notes Service

Responsibilities
----------------------------------------------------------------------------
- Encapsulate all business logic related to Notes.
- Perform ownership and authorization validation.
- Execute CRUD operations.
- Keep API routes thin and focused on HTTP concerns.
- Provide reusable methods for future features.

Architecture
----------------------------------------------------------------------------
Route
   │
   ▼
Service
   │
   ▼
Database

Notes
----------------------------------------------------------------------------
- Compatible with FastAPI.
- Compatible with SQLAlchemy 2.x.
- Supports both PUT and PATCH update operations.
"""

from collections.abc import Sequence

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.note import Note
from app.models.user import User
from app.schemas.note import NoteCreate, NoteUpdate

__all__ = (
    "create_note",
    "get_notes",
    "get_note_by_id",
    "update_note",
    "delete_note",
)

# =============================================================================
# Constants
# =============================================================================

_NOTE_NOT_FOUND = "Note not found."
_NOTE_ACCESS_DENIED = "You are not authorized to access this note."
_NO_UPDATE_FIELDS = "No fields were provided for update."


# =============================================================================
# Private Helpers
# =============================================================================


def _get_note_or_404(
    db: Session,
    note_id: int,
) -> Note:
    """
    Retrieve a note by its primary key.

    Raises:
        HTTPException: If the note does not exist.
    """

    note = db.get(Note, note_id)

    if note is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=_NOTE_NOT_FOUND,
        )

    return note


def _validate_note_access(
    note: Note,
    current_user: User,
) -> None:
    """
    Validate whether the current user can access the note.

    Admin users may access any note.
    Regular users may access only their own notes.
    """

    if current_user.role == "admin":
        return

    if note.owner_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=_NOTE_ACCESS_DENIED,
        )


# =============================================================================
# Create Note
# =============================================================================


def create_note(
    db: Session,
    user_id: int,
    note: NoteCreate,
) -> Note:
    """
    Create a new note for the authenticated user.
    """

    db_note = Note(
        title=note.title,
        content=note.content,
        owner_id=user_id,
    )

    db.add(db_note)
    db.commit()
    db.refresh(db_note)

    return db_note


# =============================================================================
# Get Notes (Paginated)
# =============================================================================


def get_notes(
    db: Session,
    user_id: int,
    skip: int = 0,
    limit: int = 10,
) -> Sequence[Note]:
    """
    Retrieve paginated notes belonging to the authenticated user,
    ordered by newest first.
    """

    return (
        db.query(Note)
        .filter(Note.owner_id == user_id)
        .order_by(Note.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )


# =============================================================================
# Get Note By ID
# =============================================================================


def get_note_by_id(
    db: Session,
    current_user: User,
    note_id: int,
) -> Note:
    """
    Retrieve a single note after validating ownership.
    """

    note = _get_note_or_404(
        db=db,
        note_id=note_id,
    )

    _validate_note_access(
        note=note,
        current_user=current_user,
    )

    return note


# =============================================================================
# Update Note (PUT / PATCH)
# =============================================================================


def update_note(
    db: Session,
    current_user: User,
    note_id: int,
    note_data: NoteUpdate,
) -> Note:
    """
    Update a note.

    Supports both PUT (full update) and
    PATCH (partial update).

    Only fields explicitly provided by the client
    are updated.
    """

    note = get_note_by_id(
        db=db,
        current_user=current_user,
        note_id=note_id,
    )

    update_data = note_data.model_dump(
        exclude_unset=True,
        exclude_none=True,
    )

    if not update_data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=_NO_UPDATE_FIELDS,
        )

    for field, value in update_data.items():
        setattr(note, field, value)

    db.commit()
    db.refresh(note)

    return note


# =============================================================================
# Delete Note
# =============================================================================


def delete_note(
    db: Session,
    current_user: User,
    note_id: int,
) -> bool:
    """
    Delete a note owned by the authenticated user.
    """

    note = get_note_by_id(
        db=db,
        current_user=current_user,
        note_id=note_id,
    )

    db.delete(note)
    db.commit()

    return True