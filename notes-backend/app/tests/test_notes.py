"""
===============================================================================
File: test_notes.py
===============================================================================

Notes API Tests

Responsibilities
----------------------------------------------------------------------------
- Test Notes CRUD operations.
- Test authenticated access.
- Test pagination.
- Test partial updates (PATCH).
- Validate API responses.

Notes
----------------------------------------------------------------------------
- Uses SQLite test database.
- Uses FastAPI TestClient.
- Independent from production database.
"""

# =============================================================================
# Authentication Helper
# =============================================================================


def get_token(client):
    """
    Register a test user and return a JWT access token.
    """

    client.post(
        "/api/v1/auth/register",
        json={
            "email": "note@example.com",
            "password": "password123",
        },
    )

    response = client.post(
        "/api/v1/auth/login",
        json={
            "email": "note@example.com",
            "password": "password123",
        },
    )

    assert response.status_code == 200

    return response.json()["access_token"]


# =============================================================================
# Create Note
# =============================================================================


def test_create_note(test_client):
    token = get_token(test_client)

    response = test_client.post(
        "/api/v1/notes",
        json={
            "title": "Test Note",
            "content": "Hello",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 201

    data = response.json()

    assert data["title"] == "Test Note"
    assert data["content"] == "Hello"
    assert isinstance(data["id"], int)


# =============================================================================
# Get Notes
# =============================================================================


def test_get_notes(test_client):
    token = get_token(test_client)

    test_client.post(
        "/api/v1/notes",
        json={
            "title": "My Note",
            "content": "Content",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    response = test_client.get(
        "/api/v1/notes?page=1&limit=10",
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert isinstance(data, list)
    assert len(data) >= 1


# =============================================================================
# Get Note By ID
# =============================================================================


def test_get_note_by_id(test_client):
    token = get_token(test_client)

    create_response = test_client.post(
        "/api/v1/notes",
        json={
            "title": "Important Note",
            "content": "Hello World",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    note_id = create_response.json()["id"]

    response = test_client.get(
        f"/api/v1/notes/{note_id}",
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert data["id"] == note_id
    assert data["title"] == "Important Note"


# =============================================================================
# Update Note (PUT)
# =============================================================================


def test_update_note(test_client):
    token = get_token(test_client)

    create_response = test_client.post(
        "/api/v1/notes",
        json={
            "title": "Old Title",
            "content": "Old Content",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    note_id = create_response.json()["id"]

    response = test_client.put(
        f"/api/v1/notes/{note_id}",
        json={
            "title": "New Title",
            "content": "New Content",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert data["title"] == "New Title"
    assert data["content"] == "New Content"


# =============================================================================
# Partial Update (PATCH)
# =============================================================================


def test_patch_note(test_client):
    token = get_token(test_client)

    create_response = test_client.post(
        "/api/v1/notes",
        json={
            "title": "Original Title",
            "content": "Original Content",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    note_id = create_response.json()["id"]

    response = test_client.patch(
        f"/api/v1/notes/{note_id}",
        json={
            "title": "Updated Title",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert data["title"] == "Updated Title"
    assert data["content"] == "Original Content"


# =============================================================================
# Delete Note
# =============================================================================


def test_delete_note(test_client):
    token = get_token(test_client)

    create_response = test_client.post(
        "/api/v1/notes",
        json={
            "title": "Delete Me",
            "content": "Temporary",
        },
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    note_id = create_response.json()["id"]

    response = test_client.delete(
        f"/api/v1/notes/{note_id}",
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == 204