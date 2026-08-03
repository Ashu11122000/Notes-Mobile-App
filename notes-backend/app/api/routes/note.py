"""
===============================================================================
File: note.py
===============================================================================

Notes Routes

Responsibilities
-------------------------------------------------------------------------------
- Expose REST endpoints for Notes.
- Validate request payloads.
- Delegate business logic to the service layer.
- Return response models.
- Never access the database directly.

Compatible With
-------------------------------------------------------------------------------
- FastAPI 0.136+
- SQLAlchemy 2.x
- Pydantic V2
===============================================================================
"""

from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Path, Query, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.core.config import settings
from app.db.session import get_db
from app.models.user import User
from app.schemas.note import NoteCreate, NoteResponse, NoteUpdate
from app.services import note_service
from app.services.note_service import (
    EmptyUpdateError,
    NoteAccessDeniedError,
    NoteNotFoundError,
)

__all__ = ("router",)

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
# Exception Translator
# =============================================================================

def _translate_exception(exc: Exception) -> None:
    if isinstance(exc, NoteNotFoundError):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Note not found.",
        ) from exc

    if isinstance(exc, NoteAccessDeniedError):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied.",
        ) from exc

    if isinstance(exc, EmptyUpdateError):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields supplied for update.",
        ) from exc

    raise exc


# =============================================================================
# Create Note
# =============================================================================

@router.post(
    "",
    response_model=NoteResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create Note",
)
def create_note(
    note: NoteCreate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    return note_service.create_note(
        db=db,
        user_id=current_user.id,
        note=note,
    )


# =============================================================================
# Get Notes
# =============================================================================

@router.get(
    "",
    response_model=list[NoteResponse],
    summary="Get Notes",
)
def get_notes(
    db: DBSession,
    current_user: CurrentUser,
    page: Annotated[
        int,
        Query(
            ge=1,
            description="Page number.",
        ),
    ] = 1,
    limit: Annotated[
        int,
        Query(
            ge=1,
            le=settings.MAX_PAGE_SIZE,
            description="Items per page.",
        ),
    ] = settings.DEFAULT_PAGE_SIZE,
) -> list[NoteResponse]:
    skip = (page - 1) * limit

    return note_service.get_notes(
        db=db,
        user_id=current_user.id,
        skip=skip,
        limit=limit,
    )


# =============================================================================
# Get Note
# =============================================================================

@router.get(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Get Note",
)
def get_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Note ID.",
        ),
    ],
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    try:
        return note_service.get_note_by_id(
            db=db,
            current_user=current_user,
            note_id=note_id,
        )

    except Exception as exc:
        _translate_exception(exc)
        raise


# =============================================================================
# Update Note
# =============================================================================

@router.put(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Replace Note",
)
def update_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Note ID.",
        ),
    ],
    note_data: NoteUpdate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    try:
        return note_service.update_note(
            db=db,
            current_user=current_user,
            note_id=note_id,
            note_data=note_data,
        )

    except Exception as exc:
        _translate_exception(exc)
        raise


# =============================================================================
# Patch Note
# =============================================================================

@router.patch(
    "/{note_id}",
    response_model=NoteResponse,
    summary="Update Note",
)
def patch_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Note ID.",
        ),
    ],
    note_data: NoteUpdate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:
    return update_note(
        note_id=note_id,
        note_data=note_data,
        db=db,
        current_user=current_user,
    )


# =============================================================================
# Delete Note
# =============================================================================

@router.delete(
    "/{note_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete Note",
)
def delete_note(
    note_id: Annotated[
        int,
        Path(
            ge=1,
            description="Note ID.",
        ),
    ],
    db: DBSession,
    current_user: CurrentUser,
) -> None:
    try:
        note_service.delete_note(
            db=db,
            current_user=current_user,
            note_id=note_id,
        )

    except Exception as exc:
        _translate_exception(exc)
        raise