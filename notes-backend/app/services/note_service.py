from __future__ import annotations

from collections.abc import Sequence

from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.models.note import Note
from app.models.user import ROLE_ADMIN, User
from app.schemas.note import NoteCreate, NoteUpdate


class NoteNotFoundError(Exception):
    pass


class NoteAccessDeniedError(Exception):
    pass


class EmptyUpdateError(Exception):
    pass


def _get_note(
    db: Session,
    note_id: int,
) -> Note:

    note = db.get(Note, note_id)

    if note is None:
        raise NoteNotFoundError

    return note


def _check_access(
    note: Note,
    current_user: User,
) -> None:

    if current_user.role == ROLE_ADMIN:
        return

    if note.owner_id != current_user.id:
        raise NoteAccessDeniedError


def create_note(
    db: Session,
    user_id: int,
    note: NoteCreate,
) -> Note:

    entity = Note(
        title=note.title,
        content=note.content,
        owner_id=user_id,
    )

    db.add(entity)

    try:
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        raise

    db.refresh(entity)

    return entity


def get_notes(
    db: Session,
    user_id: int,
    skip: int = 0,
    limit: int = 10,
) -> Sequence[Note]:

    stmt = (
        select(Note)
        .where(Note.owner_id == user_id)
        .order_by(Note.created_at.desc())
        .offset(skip)
        .limit(limit)
    )

    return db.scalars(stmt).all()


def get_note_by_id(
    db: Session,
    current_user: User,
    note_id: int,
) -> Note:

    note = _get_note(db, note_id)

    _check_access(
        note,
        current_user,
    )

    return note


def update_note(
    db: Session,
    current_user: User,
    note_id: int,
    note_data: NoteUpdate,
) -> Note:

    note = get_note_by_id(
        db,
        current_user,
        note_id,
    )

    updates = note_data.model_dump(
        exclude_unset=True,
        exclude_none=True,
    )

    if not updates:
        raise EmptyUpdateError

    for key, value in updates.items():
        setattr(note, key, value)

    try:
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        raise

    db.refresh(note)

    return note


def delete_note(
    db: Session,
    current_user: User,
    note_id: int,
) -> None:

    note = get_note_by_id(
        db,
        current_user,
        note_id,
    )

    db.delete(note)

    try:
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        raise