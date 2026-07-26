"""
===============================================================================
File: test_notes.py
===============================================================================

Notes API Tests

Responsibilities
----------------------------------------------------------------------------
- Test Notes CRUD operations.
- Test authentication and authorization.
- Test pagination.
- Test validation.
- Test partial updates.
- Validate API responses.

Notes
----------------------------------------------------------------------------
- Uses SQLite test database.
- Uses FastAPI TestClient.
- Independent from production database.
"""

from fastapi import status

# =============================================================================
# Constants
# =============================================================================

REGISTER_URL = "/api/v1/auth/register"
LOGIN_URL = "/api/v1/auth/login"
NOTES_URL = "/api/v1/notes"

EMAIL = "note@example.com"
PASSWORD = "password123"


# =============================================================================
# Helpers
# =============================================================================


def get_token(client) -> str:
    """
    Register a test user and return a JWT access token.
    """

    client.post(
        REGISTER_URL,
        json={
            "email": EMAIL,
            "password": PASSWORD,
        },
    )

    response = client.post(
        LOGIN_URL,
        json={
            "email": EMAIL,
            "password": PASSWORD,
        },
    )

    assert response.status_code == status.HTTP_200_OK

    return response.json()["access_token"]


def auth_headers(token: str) -> dict[str, str]:
    """
    Authorization header helper.
    """

    return {
        "Authorization": f"Bearer {token}",
    }


def create_note(
    client,
    token: str,
    title: str = "Test Note",
    content: str = "Test Content",
):
    """
    Create a note.
    """

    return client.post(
        NOTES_URL,
        json={
            "title": title,
            "content": content,
        },
        headers=auth_headers(token),
    )


# =============================================================================
# Create
# =============================================================================


def test_create_note(test_client):
    token = get_token(test_client)

    response = create_note(test_client, token)

    assert response.status_code == status.HTTP_201_CREATED

    data = response.json()

    assert isinstance(data["id"], int)
    assert data["title"] == "Test Note"
    assert data["content"] == "Test Content"


def test_create_note_requires_authentication(test_client):
    response = test_client.post(
        NOTES_URL,
        json={
            "title": "Hello",
            "content": "World",
        },
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_create_note_validation(test_client):
    token = get_token(test_client)

    response = create_note(
        test_client,
        token,
        title="",
    )

    assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


# =============================================================================
# Read
# =============================================================================


def test_get_notes(test_client):
    token = get_token(test_client)

    create_note(test_client, token)

    response = test_client.get(
        f"{NOTES_URL}?page=1&limit=10",
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_200_OK

    notes = response.json()

    assert isinstance(notes, list)
    assert len(notes) == 1


def test_get_note_by_id(test_client):
    token = get_token(test_client)

    created = create_note(
        test_client,
        token,
        title="Important",
        content="Hello",
    )

    note_id = created.json()["id"]

    response = test_client.get(
        f"{NOTES_URL}/{note_id}",
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_200_OK

    note = response.json()

    assert note["id"] == note_id
    assert note["title"] == "Important"
    assert note["content"] == "Hello"


def test_get_note_not_found(test_client):
    token = get_token(test_client)

    response = test_client.get(
        f"{NOTES_URL}/99999",
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_404_NOT_FOUND


# =============================================================================
# Update
# =============================================================================


def test_update_note(test_client):
    token = get_token(test_client)

    created = create_note(test_client, token)

    note_id = created.json()["id"]

    response = test_client.put(
        f"{NOTES_URL}/{note_id}",
        json={
            "title": "Updated",
            "content": "Updated Content",
        },
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_200_OK

    note = response.json()

    assert note["title"] == "Updated"
    assert note["content"] == "Updated Content"


def test_patch_note(test_client):
    token = get_token(test_client)

    created = create_note(
        test_client,
        token,
        title="Original",
        content="Original Content",
    )

    note_id = created.json()["id"]

    response = test_client.patch(
        f"{NOTES_URL}/{note_id}",
        json={
            "title": "Patched",
        },
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_200_OK

    note = response.json()

    assert note["title"] == "Patched"
    assert note["content"] == "Original Content"


def test_patch_without_fields(test_client):
    token = get_token(test_client)

    created = create_note(test_client, token)

    note_id = created.json()["id"]

    response = test_client.patch(
        f"{NOTES_URL}/{note_id}",
        json={},
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_400_BAD_REQUEST


# =============================================================================
# Delete
# =============================================================================


def test_delete_note(test_client):
    token = get_token(test_client)

    created = create_note(test_client, token)

    note_id = created.json()["id"]

    response = test_client.delete(
        f"{NOTES_URL}/{note_id}",
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_204_NO_CONTENT

    response = test_client.get(
        f"{NOTES_URL}/{note_id}",
        headers=auth_headers(token),
    )

    assert response.status_code == status.HTTP_404_NOT_FOUND


# =============================================================================
# Authorization
# =============================================================================


def test_notes_require_authentication(test_client):
    response = test_client.get(NOTES_URL)

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_invalid_token(test_client):
    response = test_client.get(
        NOTES_URL,
        headers={
            "Authorization": "Bearer invalid.token",
        },
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED