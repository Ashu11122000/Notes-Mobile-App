"""
===============================================================================
File: test_auth.py
===============================================================================

Authentication API Tests

Responsibilities
----------------------------------------------------------------------------
- Test user registration.
- Test user login.
- Validate JWT authentication flow.
- Ensure API responses match expected behavior.

Notes
----------------------------------------------------------------------------
- Uses the SQLite test database.
- Uses FastAPI TestClient.
- Independent of the production database.
"""

# =============================================================================
# User Registration
# =============================================================================


def test_register(test_client):
    """
    Test successful user registration.
    """

    response = test_client.post(
        "/api/v1/auth/register",
        json={
            "email": "test@example.com",
            "password": "password123",
        },
    )

    assert response.status_code == 201

    data = response.json()

    assert data["message"] == "User registered successfully."
    assert isinstance(data["user_id"], int)


# =============================================================================
# User Login
# =============================================================================


def test_login(test_client):
    """
    Test successful user login.
    """

    # -------------------------------------------------------------------------
    # Register User
    # -------------------------------------------------------------------------

    register_response = test_client.post(
        "/api/v1/auth/register",
        json={
            "email": "login@example.com",
            "password": "password123",
        },
    )

    assert register_response.status_code == 201

    # -------------------------------------------------------------------------
    # Login
    # -------------------------------------------------------------------------

    response = test_client.post(
        "/api/v1/auth/login",
        json={
            "email": "login@example.com",
            "password": "password123",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert "access_token" in data
    assert data["token_type"] == "bearer"
    assert isinstance(data["access_token"], str)
    assert len(data["access_token"]) > 0