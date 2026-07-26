"""
===============================================================================
File: test_auth.py
===============================================================================

Authentication API Tests

Responsibilities
----------------------------------------------------------------------------
- Test user registration.
- Test duplicate registration.
- Test login.
- Test invalid credentials.
- Test authenticated user endpoint.
- Validate JWT authentication flow.

Notes
----------------------------------------------------------------------------
- Uses the SQLite test database.
- Uses FastAPI TestClient.
- Independent of the production database.
"""

from fastapi import status


# =============================================================================
# Constants
# =============================================================================

REGISTER_URL = "/api/v1/auth/register"
LOGIN_URL = "/api/v1/auth/login"
ME_URL = "/api/v1/auth/me"

TEST_EMAIL = "test@example.com"
TEST_PASSWORD = "password123"


# =============================================================================
# Helper
# =============================================================================


def register_user(
    client,
    email: str = TEST_EMAIL,
    password: str = TEST_PASSWORD,
):
    """
    Register a user.
    """

    return client.post(
        REGISTER_URL,
        json={
            "email": email,
            "password": password,
        },
    )


def login_user(
    client,
    email: str = TEST_EMAIL,
    password: str = TEST_PASSWORD,
):
    """
    Login a user.
    """

    return client.post(
        LOGIN_URL,
        json={
            "email": email,
            "password": password,
        },
    )


# =============================================================================
# Registration
# =============================================================================


def test_register_success(test_client):
    """
    Register a new user successfully.
    """

    response = register_user(test_client)

    assert response.status_code == status.HTTP_201_CREATED

    data = response.json()

    assert data["message"] == "User registered successfully."
    assert isinstance(data["user_id"], int)


def test_register_duplicate_email(test_client):
    """
    Duplicate registrations should fail.
    """

    register_user(test_client)

    response = register_user(test_client)

    assert response.status_code == status.HTTP_409_CONFLICT
    assert response.json()["detail"] == (
        "A user with this email already exists."
    )


def test_register_invalid_email(test_client):
    """
    Invalid email should be rejected.
    """

    response = register_user(
        test_client,
        email="invalid-email",
    )

    assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


def test_register_short_password(test_client):
    """
    Password validation.
    """

    response = register_user(
        test_client,
        password="123",
    )

    assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


# =============================================================================
# Login
# =============================================================================


def test_login_success(test_client):
    """
    Login should return a valid JWT.
    """

    register_user(test_client)

    response = login_user(test_client)

    assert response.status_code == status.HTTP_200_OK

    data = response.json()

    assert "access_token" in data
    assert data["token_type"] == "bearer"
    assert isinstance(data["access_token"], str)
    assert len(data["access_token"]) > 20


def test_login_invalid_password(test_client):
    """
    Invalid password should be rejected.
    """

    register_user(test_client)

    response = login_user(
        test_client,
        password="wrongpassword",
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED
    assert response.json()["detail"] == "Invalid email or password."


def test_login_unknown_user(test_client):
    """
    Unknown users cannot login.
    """

    response = login_user(
        test_client,
        email="unknown@example.com",
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED
    assert response.json()["detail"] == "Invalid email or password."


# =============================================================================
# Current User
# =============================================================================


def test_get_current_user(test_client):
    """
    Retrieve the authenticated user.
    """

    register_user(test_client)

    login_response = login_user(test_client)

    token = login_response.json()["access_token"]

    response = test_client.get(
        ME_URL,
        headers={
            "Authorization": f"Bearer {token}",
        },
    )

    assert response.status_code == status.HTTP_200_OK

    data = response.json()

    assert data["email"] == TEST_EMAIL
    assert data["role"] == "user"
    assert data["is_active"] is True


def test_get_current_user_without_token(test_client):
    """
    Missing JWT should return 401.
    """

    response = test_client.get(ME_URL)

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_get_current_user_invalid_token(test_client):
    """
    Invalid JWT should return 401.
    """

    response = test_client.get(
        ME_URL,
        headers={
            "Authorization": "Bearer invalid.token.value",
        },
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_get_current_user_malformed_token(test_client):
    """
    Malformed JWT should return 401.
    """

    response = test_client.get(
        ME_URL,
        headers={
            "Authorization": "Bearer abc",
        },
    )

    assert response.status_code == status.HTTP_401_UNAUTHORIZED