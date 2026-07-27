from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Path, Query, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.core.config import settings
from app.db.session import get_db
from app.models.user import User
from app.schemas.note import NoteCreate, NoteResponse, NoteUpdate
from app.services.note_service import (
    EmptyUpdateError,
    NoteAccessDeniedError,
    NoteNotFoundError,
)
from app.services import note_service

DBSession = Annotated[Session, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]

router = APIRouter(
    prefix="/notes",
    tags=["Notes"],
)


def _translate_exception(exc: Exception) -> None:
    if isinstance(exc, NoteNotFoundError):
        raise HTTPException(
            status_code=404,
            detail="Note not found.",
        ) from exc

    if isinstance(exc, NoteAccessDeniedError):
        raise HTTPException(
            status_code=403,
            detail="Access denied.",
        ) from exc

    if isinstance(exc, EmptyUpdateError):
        raise HTTPException(
            status_code=400,
            detail="No fields supplied for update.",
        ) from exc

    raise exc


@router.post(
    "",
    response_model=NoteResponse,
    status_code=status.HTTP_201_CREATED,
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


@router.get(
    "",
    response_model=list[NoteResponse],
)
def get_notes(
    page: Annotated[
        int,
        Query(ge=1),
    ] = 1,
    limit: Annotated[
        int,
        Query(
            ge=1,
            le=settings.MAX_PAGE_SIZE,
        ),
    ] = settings.DEFAULT_PAGE_SIZE,
    db: DBSession = Depends(get_db),
    current_user: CurrentUser = Depends(get_current_user),
) -> list[NoteResponse]:

    skip = (page - 1) * limit

    return note_service.get_notes(
        db=db,
        user_id=current_user.id,
        skip=skip,
        limit=limit,
    )


@router.get(
    "/{note_id}",
    response_model=NoteResponse,
)
def get_note(
    note_id: Annotated[
        int,
        Path(ge=1),
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


@router.put(
    "/{note_id}",
    response_model=NoteResponse,
)
def update_note(
    note_id: int,
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


@router.patch(
    "/{note_id}",
    response_model=NoteResponse,
)
def patch_note(
    note_id: int,
    note_data: NoteUpdate,
    db: DBSession,
    current_user: CurrentUser,
) -> NoteResponse:

    return update_note(
        note_id,
        note_data,
        db,
        current_user,
    )


@router.delete(
    "/{note_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_note(
    note_id: int,
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