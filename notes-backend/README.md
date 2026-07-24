# Notes Backend API

> A production-ready RESTful backend built with **FastAPI**, following clean architecture and enterprise development practices. The application provides secure JWT authentication, role-based authorization, notes management, pagination, Docker support, automated testing, and comprehensive API documentation.

---

## Overview

The **Notes Backend API** is a scalable REST API developed using **FastAPI** and **PostgreSQL**. It demonstrates modern backend development practices by implementing secure authentication, modular architecture, clean separation of concerns, and containerized deployment.

The backend is designed to serve multiple clients, including:

- Flutter Mobile Application
- Next.js Web Application
- Third-party REST API consumers

The project follows a layered architecture that separates routing, business logic, database operations, and data validation, making the codebase easier to maintain, test, and extend.

---

## Key Features

### Authentication & Authorization

- JWT-based Authentication
- Secure Password Hashing using Passlib (bcrypt)
- User Registration
- User Login
- Current Authenticated User Endpoint
- Role-Based Access Control (RBAC)
- Protected API Routes

### Notes Management

- Create Notes
- Retrieve All Notes
- Retrieve Note by ID
- Update Notes (PUT)
- Partial Update Notes (PATCH)
- Delete Notes
- User Ownership Validation
- Pagination Support

### API Documentation

- Interactive Swagger UI
- ReDoc Documentation
- OpenAPI Specification

### Database

- PostgreSQL
- SQLAlchemy 2.x ORM
- Automatic Table Creation
- Relationship Mapping

### Security

- JWT Access Tokens
- Password Hashing
- Authorization Middleware
- Route Protection
- Ownership Validation

### Testing

- Pytest
- FastAPI TestClient
- SQLite Test Database
- Authentication Tests
- CRUD Tests
- JWT Validation Tests

### Deployment

- Docker
- Docker Compose
- Environment Variable Configuration
- Production-ready Containerization

---

## Project Goals

This project demonstrates enterprise backend development principles including:

- Clean Architecture
- Modular Design
- Separation of Concerns
- RESTful API Design
- Secure Authentication
- Role-Based Authorization
- Production-ready Docker Setup
- Automated Testing
- API Documentation
- Scalable Code Structure

---

## Technology Stack

| Category | Technology |
|----------|------------|
| Language | Python 3.12 |
| Framework | FastAPI |
| Database | PostgreSQL |
| ORM | SQLAlchemy 2.x |
| Validation | Pydantic V2 |
| Authentication | JWT (python-jose) |
| Password Hashing | Passlib + bcrypt |
| API Documentation | Swagger UI & ReDoc |
| Testing | Pytest |
| Containerization | Docker |
| API Client | Postman |

---

## Architecture Overview

```
                        Client Applications
                                │
        ┌───────────────────────┼────────────────────────┐
        │                       │                        │
        ▼                       ▼                        ▼
 Flutter Mobile           Next.js Web             REST Clients
        │                       │                        │
        └───────────────────────┼────────────────────────┘
                                │
                                ▼
                     FastAPI REST API
                                │
          ┌─────────────────────┼─────────────────────┐
          ▼                     ▼                     ▼
     API Routes           Dependencies          Middleware
          │
          ▼
      Service Layer
          │
          ▼
    SQLAlchemy ORM
          │
          ▼
     PostgreSQL Database
```

---

## Request Flow

```
Client Request
      │
      ▼
FastAPI Router
      │
      ▼
Authentication Dependency
      │
      ▼
Service Layer
      │
      ▼
Database
      │
      ▼
Response Model
      │
      ▼
JSON Response
```

---

## Project Structure

```text
app/
├── main.py
│
├── core/
│   ├── config.py
│   ├── security.py
│
├── db/
│   ├── session.py
│   ├── base.py
│
├── models/
│   ├── user.py
│   ├── note.py
│
├── schemas/
│   ├── user.py
│   ├── note.py
│   ├── token.py
│
├── api/
│   ├── deps.py
│   ├── routes/
│   │   ├── auth.py
│   │   ├── note.py
│
├── services/
│   ├── user_service.py
│   ├── note_service.py
│
├── tests/
│   ├── conftest.py
│   ├── test_auth.py
│   ├── test_notes.py
│
.env
requirements.txt
Dockerfile
docker-compose.yml
README.md
```

---

## Project Architecture

The project follows a layered architecture to improve maintainability and scalability.

### API Layer

Responsible for:

- Handling HTTP requests
- Request validation
- Response serialization
- Authentication
- Authorization

---

### Service Layer

Responsible for:

- Business logic
- Database operations
- Ownership validation
- CRUD implementation

---

### Database Layer

Responsible for:

- SQLAlchemy models
- PostgreSQL communication
- Session management
- Relationship mapping

---

### Schema Layer

Responsible for:

- Request validation
- Response serialization
- Type safety
- API contracts

---

### Core Layer

Responsible for:

- Application configuration
- JWT authentication
- Password hashing
- Security utilities

---

## Project Highlights

- Production-ready REST API
- Enterprise project structure
- JWT Authentication
- Role-Based Authorization (RBAC)
- Secure Password Hashing
- PostgreSQL Integration
- SQLAlchemy 2.x
- Pydantic V2
- Dockerized Deployment
- Interactive Swagger Documentation
- Pagination Support
- Full CRUD Operations
- Partial Update (PATCH)
- Automated Unit Testing
- Flutter Ready
- Next.js Ready
- Clean Architecture
- Scalable Codebase

---

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Ashu11122000/Notes-Mobile-App.git
cd notes-backend
```

---

### 2. Create a Virtual Environment

#### Windows

```bash
python -m venv .venv
```

Activate the virtual environment:

```bash
.venv\Scripts\activate
```

#### Linux / macOS

```bash
python3 -m venv .venv
source .venv/bin/activate
```

---

### 3. Install Dependencies

Upgrade pip:

```bash
python -m pip install --upgrade pip
```

Install project dependencies:

```bash
pip install -r requirements.txt
```

---

## Running the Application

### Using Uvicorn (Local Development)

Start the development server:

```bash
uvicorn app.main:app --reload
```

Application URL

```
http://127.0.0.1:8000
```

---

## API Documentation

### Swagger UI

```
http://127.0.0.1:8000/docs
```

Interactive API documentation with request/response examples.

---

### ReDoc

```
http://127.0.0.1:8000/redoc
```

Alternative API documentation generated from the OpenAPI specification.

---

## Docker Setup

The project includes Docker support for running both the FastAPI application and PostgreSQL database inside containers.

---

### Build Docker Images

```bash
docker compose build
```

---

### Build and Start Containers

```bash
docker compose up --build
```

---

### Start Containers in Background

```bash
docker compose up -d
```

---

### View Running Containers

```bash
docker ps
```

---

### View Container Logs

Application logs:

```bash
docker logs notes_app
```

Database logs:

```bash
docker logs notes_db
```

---

### Stop Containers

```bash
docker compose down
```

---

### Stop and Remove Volumes

```bash
docker compose down -v
```

---

### Rebuild After Dependency Changes

```bash
docker compose up --build
```

---

## Docker Services

### FastAPI Application

| Property | Value |
|----------|-------|
| Container | notes_app |
| Port | 8000 |
| Framework | FastAPI |
| Server | Uvicorn |

---

### PostgreSQL Database

| Property | Value |
|----------|-------|
| Container | notes_db |
| PostgreSQL Version | 15 |
| Internal Port | 5432 |
| Host Port | 5433 |
| Database | notes_db |

---

## Development Workflow

### Local Development

```text
Create Virtual Environment
        │
        ▼
Install Dependencies
        │
        ▼
Configure .env
        │
        ▼
Start PostgreSQL
        │
        ▼
Run Uvicorn
        │
        ▼
Open Swagger
        │
        ▼
Test APIs
```

---

### Docker Development

```text
Docker Compose
        │
        ▼
Build Images
        │
        ▼
Create Containers
        │
        ▼
Start PostgreSQL
        │
        ▼
Start FastAPI
        │
        ▼
Ready to Use
```

---

## Verify Installation

After starting the application, verify everything is working correctly.

### Root Endpoint

```http
GET /
```

Expected Response

```json
{
    "service": "Notes Backend",
    "version": "1.0.0",
    "status": "running"
}
```

---

### Health Check

```http
GET /health
```

Expected Response

```json
{
    "status": "healthy"
}
```

---

## Database Configuration

The application uses PostgreSQL with SQLAlchemy ORM.

Connection URL format:

```text
postgresql+psycopg2://<username>:<password>@<host>:<port>/<database>
```

Example:

```text
postgresql+psycopg2://postgres:postgres@localhost:5433/notes_db
```

---

## Development Tools

The project uses the following development tools:

- FastAPI
- Uvicorn
- SQLAlchemy
- PostgreSQL
- Docker
- Docker Compose
- Swagger UI
- ReDoc
- Postman
- Pytest

---

## Quick Start

```bash
# Clone repository
git clone <repository-url>

# Enter project
cd notes-backend

# Create virtual environment
python -m venv .venv

# Activate virtual environment
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
# Create .env file

# Start Docker containers
docker compose up -d

# Run FastAPI
uvicorn app.main:app --reload

# Open Swagger
http://127.0.0.1:8000/docs
```

---

## Authentication

The Notes Backend API uses **JWT (JSON Web Token)** based authentication to protect secured endpoints.

Once a user logs in successfully, the server generates a signed JWT access token. This token must be included in the `Authorization` header when accessing protected resources.

---

### Authentication Flow

```text
                Register User
                      │
                      ▼
              User Created Successfully
                      │
                      ▼
                  Login User
                      │
                      ▼
             Validate Credentials
                      │
                      ▼
             Generate JWT Token
                      │
                      ▼
          Return Access Token to Client
                      │
                      ▼
      Authorization: Bearer <access_token>
                      │
                      ▼
          Protected API Endpoints
                      │
                      ▼
           JWT Validation & Authorization
```

---

## JWT Authentication

After a successful login, the API returns:

```json
{
    "access_token": "<jwt_access_token>",
    "token_type": "bearer"
}
```

Use this token for all protected endpoints.

Example:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

---

## Role-Based Access Control (RBAC)

The application implements Role-Based Access Control (RBAC) to authorize users based on their assigned roles.

Current supported roles:

| Role | Description |
|------|-------------|
| user | Default application user |
| admin | Full administrative privileges |

---

### Authorization Rules

#### User

A normal user can:

- Register
- Login
- View own profile
- Create notes
- View own notes
- Update own notes
- Delete own notes

Users **cannot** access notes belonging to other users.

---

#### Admin

An administrator can:

- Access any note
- Manage all users (future enhancement)
- Perform administrative operations

---

## API Base URL

```http
http://127.0.0.1:8000/api/v1
```

---

# Authentication APIs

---

## Register User

Creates a new user account.

### Endpoint

```http
POST /auth/register
```

### Request Body

```json
{
    "email": "ashish@example.com",
    "password": "Password123"
}
```

### Success Response

**201 Created**

```json
{
    "message": "User registered successfully.",
    "user_id": 1
}
```

### Possible Responses

| Status Code | Description |
|-------------|-------------|
| 201 | User created successfully |
| 409 | User already exists |
| 422 | Validation error |

---

## Login User

Authenticates an existing user.

### Endpoint

```http
POST /auth/login
```

### Request Body

```json
{
    "email": "ashish@example.com",
    "password": "Password123"
}
```

### Success Response

**200 OK**

```json
{
    "access_token": "<jwt_token>",
    "token_type": "bearer"
}
```

### Possible Responses

| Status Code | Description |
|-------------|-------------|
| 200 | Login successful |
| 401 | Invalid credentials |
| 422 | Validation error |

---

## Get Current User

Returns details of the currently authenticated user.

### Endpoint

```http
GET /auth/me
```

### Headers

```http
Authorization: Bearer <access_token>
```

### Success Response

```json
{
    "id": 1,
    "email": "ashish@example.com",
    "role": "user",
    "is_active": true
}
```

### Possible Responses

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 401 | Invalid or expired token |
| 403 | User inactive |

---

# Notes APIs

All Notes APIs require authentication.

Include the following header:

```http
Authorization: Bearer <access_token>
```

---

## Features

The Notes module supports:

- Create Note
- Retrieve Notes
- Pagination
- Retrieve Note by ID
- Full Update (PUT)
- Partial Update (PATCH)
- Delete Note
- Ownership Validation

---

## Pagination

Large datasets are returned using pagination.

### Query Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| page | Current page number | 1 |
| limit | Records per page | 10 |

Example:

```http
GET /notes?page=1&limit=10
```

Internal calculation:

```python
skip = (page - 1) * limit
```

Example:

| Page | Skip |
|------|------|
| 1 | 0 |
| 2 | 10 |
| 3 | 20 |

---

# API Summary

## Authentication

| Method | Endpoint | Authentication |
|---------|----------|---------------|
| POST | `/auth/register` | ❌ |
| POST | `/auth/login` | ❌ |
| GET | `/auth/me` | ✅ |

---

## Notes

| Method | Endpoint | Authentication |
|---------|----------|---------------|
| POST | `/notes` | ✅ |
| GET | `/notes?page=1&limit=10` | ✅ |
| GET | `/notes/{id}` | ✅ |
| PUT | `/notes/{id}` | ✅ |
| PATCH | `/notes/{id}` | ✅ |
| DELETE | `/notes/{id}` | ✅ |

---

## Security Features

The backend implements several security mechanisms.

### Password Hashing

- Passlib
- bcrypt
- One-way hashing
- Passwords are never stored in plain text

---

### JWT Security

Each token contains:

- User identity
- User role
- Expiration time

Expired or invalid tokens are automatically rejected.

---

### Ownership Validation

Every note belongs to a specific user.

Before returning, updating, or deleting a note, the application verifies ownership.

Example flow:

```text
Request
    │
    ▼
Validate JWT
    │
    ▼
Retrieve Current User
    │
    ▼
Find Note
    │
    ▼
Verify Owner
    │
    ▼
Allow / Deny Access
```

---

## Error Responses

Common API responses:

| Status Code | Meaning |
|-------------|---------|
| 200 | Success |
| 201 | Resource Created |
| 204 | Resource Deleted |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Resource Not Found |
| 409 | Conflict |
| 422 | Validation Error |
| 500 | Internal Server Error |

---

## API Design Principles

The backend follows RESTful API best practices.

- REST architecture
- Layered design
- Resource-based endpoints
- JSON request/response
- Stateless authentication
- JWT authorization
- Pagination support
- Enterprise folder structure
- Clean service layer
- Reusable dependencies
- Swagger/OpenAPI documentation

---

# Complete API Reference

This section documents all available REST API endpoints with request and response examples.

---

# Authentication APIs

---

## Register User

Creates a new user account.

### Endpoint

```http
POST /api/v1/auth/register
```

### Headers

```http
Content-Type: application/json
```

### Request Body

```json
{
    "email": "ashish@example.com",
    "password": "Password123"
}
```

### Success Response

**201 Created**

```json
{
    "message": "User registered successfully.",
    "user_id": 1
}
```

### Error Responses

#### User Already Exists

```http
409 Conflict
```

```json
{
    "detail": "A user with this email already exists."
}
```

---

#### Validation Error

```http
422 Unprocessable Entity
```

---

# Login User

Authenticates a user and returns a JWT access token.

### Endpoint

```http
POST /api/v1/auth/login
```

### Headers

```http
Content-Type: application/json
```

### Request Body

```json
{
    "email": "ashish@example.com",
    "password": "Password123"
}
```

### Success Response

```json
{
    "access_token": "<jwt_access_token>",
    "token_type": "bearer"
}
```

### Error Response

```http
401 Unauthorized
```

```json
{
    "detail": "Invalid email or password."
}
```

---

# Current User

Returns the authenticated user's profile.

### Endpoint

```http
GET /api/v1/auth/me
```

### Headers

```http
Authorization: Bearer <access_token>
```

### Success Response

```json
{
    "id": 1,
    "email": "ashish@example.com",
    "role": "user",
    "is_active": true
}
```

---

# Notes APIs

All Notes APIs require authentication.

Required header:

```http
Authorization: Bearer <access_token>
```

---

# Create Note

Creates a new note.

### Endpoint

```http
POST /api/v1/notes
```

### Request Body

```json
{
    "title": "Shopping List",
    "content": "Milk, Bread, Eggs"
}
```

### Success Response

```json
{
    "id": 1,
    "title": "Shopping List",
    "content": "Milk, Bread, Eggs",
    "owner_id": 1,
    "created_at": "2026-07-24T11:30:20",
    "updated_at": "2026-07-24T11:30:20"
}
```

---

# Get All Notes

Returns paginated notes for the authenticated user.

### Endpoint

```http
GET /api/v1/notes?page=1&limit=10
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | integer | No | Page number |
| limit | integer | No | Records per page |

### Success Response

```json
[
    {
        "id": 1,
        "title": "Shopping List",
        "content": "Milk, Bread, Eggs",
        "owner_id": 1,
        "created_at": "2026-07-24T11:30:20",
        "updated_at": "2026-07-24T11:30:20"
    }
]
```

---

# Get Note By ID

Returns a single note.

### Endpoint

```http
GET /api/v1/notes/{note_id}
```

Example

```http
GET /api/v1/notes/1
```

### Success Response

```json
{
    "id": 1,
    "title": "Shopping List",
    "content": "Milk, Bread, Eggs",
    "owner_id": 1,
    "created_at": "2026-07-24T11:30:20",
    "updated_at": "2026-07-24T11:30:20"
}
```

### Error Response

```http
404 Not Found
```

```json
{
    "detail": "Note not found"
}
```

---

# Update Note (PUT)

Completely replaces an existing note.

### Endpoint

```http
PUT /api/v1/notes/{note_id}
```

Example

```http
PUT /api/v1/notes/1
```

### Request Body

```json
{
    "title": "Updated Shopping List",
    "content": "Milk, Bread, Eggs, Butter"
}
```

### Success Response

```json
{
    "id": 1,
    "title": "Updated Shopping List",
    "content": "Milk, Bread, Eggs, Butter",
    "owner_id": 1,
    "created_at": "2026-07-24T11:30:20",
    "updated_at": "2026-07-24T12:10:15"
}
```

---

# Partial Update Note (PATCH)

Updates only the supplied fields.

### Endpoint

```http
PATCH /api/v1/notes/{note_id}
```

Example

```http
PATCH /api/v1/notes/1
```

---

## Update Only Title

```json
{
    "title": "Groceries"
}
```

---

## Update Only Content

```json
{
    "content": "Milk, Bread, Eggs, Butter, Cheese"
}
```

---

## Update Both

```json
{
    "title": "Weekly Shopping",
    "content": "Milk, Eggs"
}
```

### Success Response

```json
{
    "id": 1,
    "title": "Weekly Shopping",
    "content": "Milk, Eggs",
    "owner_id": 1,
    "created_at": "2026-07-24T11:30:20",
    "updated_at": "2026-07-24T12:20:40"
}
```

---

# Delete Note

Deletes a note.

### Endpoint

```http
DELETE /api/v1/notes/{note_id}
```

Example

```http
DELETE /api/v1/notes/1
```

### Success Response

```http
204 No Content
```

---

# Health Check

Returns the application health status.

### Endpoint

```http
GET /health
```

### Success Response

```json
{
    "status": "healthy"
}
```

---

# Root Endpoint

Returns general API information.

### Endpoint

```http
GET /
```

### Success Response

```json
{
    "service": "Notes Backend",
    "version": "1.0.0",
    "status": "running"
}
```

---

# Pagination

The Notes API supports pagination.

Example:

```http
GET /api/v1/notes?page=1&limit=10
```

### Parameters

| Name | Description | Default |
|------|-------------|---------|
| page | Current page | 1 |
| limit | Items per page | 10 |

Internal logic:

```python
skip = (page - 1) * limit
```

Example:

| Page | Skip |
|------|------|
| 1 | 0 |
| 2 | 10 |
| 3 | 20 |

---

# Authentication Header

Every protected endpoint requires the following header:

```http
Authorization: Bearer <access_token>
```

---

# API Summary

| Method | Endpoint | Authentication |
|---------|----------|----------------|
| POST | `/api/v1/auth/register` | ❌ |
| POST | `/api/v1/auth/login` | ❌ |
| GET | `/api/v1/auth/me` | ✅ |
| POST | `/api/v1/notes` | ✅ |
| GET | `/api/v1/notes?page=1&limit=10` | ✅ |
| GET | `/api/v1/notes/{note_id}` | ✅ |
| PUT | `/api/v1/notes/{note_id}` | ✅ |
| PATCH | `/api/v1/notes/{note_id}` | ✅ |
| DELETE | `/api/v1/notes/{note_id}` | ✅ |
| GET | `/health` | ❌ |
| GET | `/` | ❌ |

---

# Postman Testing

Test the APIs in the following order:

1. Register User
2. Login User
3. Copy JWT Access Token
4. Get Current User
5. Create Note
6. Get All Notes
7. Get Note By ID
8. Update Note (PUT)
9. Partial Update (PATCH)
10. Delete Note
11. Health Check

---

# Swagger Documentation

Interactive API documentation is available at:

```text
http://127.0.0.1:8000/docs
```

Alternative API documentation:

```text
http://127.0.0.1:8000/redoc
```

---

# Testing

The project includes an automated test suite built with **Pytest** to validate authentication, authorization, and Notes CRUD functionality.

The tests are designed to be independent from the production database by using a dedicated SQLite test database.

---

## Testing Stack

| Category | Technology |
|----------|------------|
| Testing Framework | Pytest |
| API Testing | FastAPI TestClient |
| Test Database | SQLite |
| ORM | SQLAlchemy 2.x |
| Dependency Override | FastAPI Dependency Injection |

---

## Running Tests

Execute all tests:

```bash
pytest
```

Run tests with verbose output:

```bash
pytest -v
```

Run a specific test file:

```bash
pytest tests/test_auth.py
```

```bash
pytest tests/test_notes.py
```

Run a specific test function:

```bash
pytest tests/test_notes.py::test_create_note
```

---

## Test Database

The application uses an isolated SQLite database during testing.

```
Production
        │
        ▼
 PostgreSQL Database

Testing
        │
        ▼
 SQLite Database
```

Each test creates a fresh database and removes it after execution, ensuring complete isolation.

---

## Authentication Tests

Authentication tests verify the complete JWT authentication flow.

### Covered Scenarios

- User Registration
- Duplicate User Registration
- User Login
- Invalid Login Credentials
- JWT Token Generation
- Current Authenticated User
- Invalid Token Handling
- Expired Token Validation

---

## Notes Tests

Notes module tests verify complete CRUD functionality.

### Covered Scenarios

- Create Note
- Get All Notes
- Pagination
- Get Note By ID
- Update Note (PUT)
- Partial Update (PATCH)
- Delete Note
- Unauthorized Access
- Ownership Validation

---

## Authorization Tests

The backend verifies authorization for every protected request.

Covered scenarios include:

- Missing JWT Token
- Invalid JWT Token
- Expired JWT Token
- Inactive User
- Accessing Another User's Notes
- Role-Based Authorization (RBAC)

---

## Test Flow

```
Create Test Database
        │
        ▼
Register User
        │
        ▼
Login User
        │
        ▼
Generate JWT
        │
        ▼
Call Protected API
        │
        ▼
Validate Response
        │
        ▼
Delete Test Database
```

---

## Current Test Coverage

### Authentication

- Register User
- Login User
- Get Current User
- JWT Authentication

---

### Notes

- Create Note
- Get Notes
- Pagination
- Get Note by ID
- Update Note (PUT)
- Partial Update (PATCH)
- Delete Note

---

### Security

- Password Hashing
- JWT Validation
- Protected Routes
- Ownership Verification
- RBAC

---

## Testing Best Practices

The test suite follows the following principles:

- Independent tests
- Fresh database for each test
- Reusable fixtures
- Dependency overrides
- Real HTTP requests
- Predictable test data

---

# Flutter Integration

The backend is designed to be consumed directly by a Flutter application.

---

## Supported Features

The Flutter application can integrate with the following backend features:

### Authentication

- Register
- Login
- JWT Authentication
- Current User

---

### Notes

- Create Notes
- View Notes
- Pagination
- Update Notes
- Partial Update Notes
- Delete Notes

---

### Security

- Bearer Token Authentication
- JWT Validation
- Protected APIs

---

## Flutter Architecture

```
Flutter UI
      │
      ▼
State Management
      │
      ▼
Repository
      │
      ▼
REST API
      │
      ▼
FastAPI Backend
      │
      ▼
PostgreSQL
```

---

## Flutter API Flow

```
Login
    │
    ▼
Receive JWT
    │
    ▼
Store Token
    │
    ▼
Call Protected APIs
    │
    ▼
Display Notes
```

---

## Local Data Persistence

Recommended Flutter packages:

- shared_preferences
- sqflite

Suggested usage:

- Store JWT Token
- Store Theme Preference
- Cache Recent Notes

---

## Image Picker

Recommended package:

```
image_picker
```

Suggested implementation:

- Select image from Gallery
- Attach image path locally
- Display image inside note

---

## Local Notifications

Recommended package:

```
flutter_local_notifications
```

Suggested use cases:

- Reminder for important notes
- Due-date notifications
- Scheduled reminders
- Recurring reminders

---

## State Management

Recommended options:

- Provider
- Riverpod
- Bloc
- GetX

For this project, **Provider** or **Riverpod** is recommended due to simplicity and scalability.

---

## Pagination Support

The backend already supports pagination.

Example:

```http
GET /api/v1/notes?page=1&limit=10
```

Flutter can implement:

- Infinite Scroll
- Pull-to-Refresh
- Lazy Loading

without any backend changes.

---

## CI/CD

The project is compatible with Codemagic.

Recommended pipeline:

```
Flutter Analyze
        │
        ▼
Flutter Test
        │
        ▼
Build APK
        │
        ▼
Publish Artifact
```

---

## Future Improvements

Possible future enhancements include:

### Authentication

- Refresh Tokens
- Email Verification
- Password Reset
- Multi-Factor Authentication (MFA)
- Google OAuth
- GitHub OAuth

---

### Notes

- Note Categories
- Tags
- Search Notes
- Rich Text Editor
- Attachments
- Soft Delete
- Archive Notes
- Favorite Notes

---

### Collaboration

- Shared Notes
- Real-time Synchronization
- Comments
- Activity History

---

### Performance

- Redis Caching
- Background Tasks
- Async Database Queries
- Connection Pool Optimization

---

### API Improvements

- API Versioning
- Response Standardization
- Global Exception Handler
- Request Logging
- Rate Limiting
- OpenTelemetry
- API Metrics

---

### Deployment

- GitHub Actions
- Kubernetes
- Nginx Reverse Proxy
- HTTPS
- Docker Registry
- CI/CD Pipelines

---

## Project Roadmap

```
Authentication
        │
        ▼
Notes CRUD
        │
        ▼
Pagination
        │
        ▼
Flutter App
        │
        ▼
Notifications
        │
        ▼
Production Deployment
```

---

# Production Notes

This project is structured as a production-oriented backend application and follows modern backend development practices.

Although intentionally kept lightweight for learning and evaluation purposes, the architecture allows new features to be added with minimal refactoring.

---

## Production-Ready Features

The project currently includes:

- JWT Authentication
- Role-Based Access Control (RBAC)
- Password Hashing using bcrypt
- PostgreSQL Integration
- SQLAlchemy 2.x ORM
- Pydantic V2 Validation
- Docker & Docker Compose
- Swagger Documentation
- ReDoc Documentation
- Pagination
- Full CRUD Operations
- Partial Update (PATCH)
- Automated Testing with Pytest
- Clean Architecture
- Service Layer Pattern
- Dependency Injection
- Environment-based Configuration

---

# Security Features

The application follows several security best practices.

## Authentication

- JWT Access Tokens
- Protected Endpoints
- Stateless Authentication

---

## Password Security

Passwords are never stored in plain text.

The application uses:

- Passlib
- bcrypt

for secure password hashing.

---

## Authorization

Every protected endpoint validates:

- JWT Signature
- Token Expiration
- Current User
- User Status
- Resource Ownership

---

## Input Validation

All incoming requests are validated using **Pydantic V2**.

Validation includes:

- Required fields
- Email format
- Password length
- Title length
- Data types

---

## Database Security

The backend uses SQLAlchemy ORM which provides protection against SQL Injection through parameterized queries.

---

# Best Practices Followed

The project follows modern backend development practices.

## Project Structure

- Modular Architecture
- Layered Design
- Separation of Concerns
- Reusable Components

---

## API Design

- RESTful APIs
- Resource-based Endpoints
- Proper HTTP Methods
- Standard HTTP Status Codes
- JSON Responses

---

## Code Quality

- Type Hints
- Clean Code
- Reusable Services
- Dependency Injection
- Minimal Route Logic

---

## Error Handling

The application returns meaningful HTTP status codes.

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 201 | Resource Created |
| 204 | Resource Deleted |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 422 | Validation Error |
| 500 | Internal Server Error |

---

# Troubleshooting

## Docker Container Not Starting

Check running containers:

```bash
docker ps
```

View logs:

```bash
docker logs notes_app
```

Rebuild containers:

```bash
docker compose up --build
```

---

## Database Connection Error

Verify:

- PostgreSQL container is running.
- Environment variables are correct.
- Database port matches the `.env` file.

Check PostgreSQL container:

```bash
docker ps
```

---

## Uvicorn Not Starting

Ensure the virtual environment is activated.

```bash
.venv\Scripts\activate
```

Run:

```bash
uvicorn app.main:app --reload
```

---

## Swagger Not Loading

Verify that the server is running.

Open:

```
http://127.0.0.1:8000/docs
```

---

## JWT Authentication Errors

Ensure:

- Token is copied correctly.
- Authorization header is present.
- Token has not expired.

Example:

```http
Authorization: Bearer <access_token>
```

---

## Running Tests

Execute:

```bash
pytest
```

If tests fail:

- Ensure dependencies are installed.
- Ensure the virtual environment is active.
- Verify the test database configuration.

---

# Project Statistics

| Category | Value |
|----------|-------|
| Framework | FastAPI |
| Language | Python 3.12 |
| Database | PostgreSQL |
| ORM | SQLAlchemy 2.x |
| Validation | Pydantic V2 |
| Authentication | JWT |
| Testing | Pytest |
| Containerization | Docker |
| Documentation | Swagger & ReDoc |

---

# API Features

Authentication

- User Registration
- User Login
- Current User

---

Notes

- Create Note
- Get All Notes
- Pagination
- Get Note by ID
- Update Note (PUT)
- Partial Update (PATCH)
- Delete Note

---

Infrastructure

- Docker Support
- PostgreSQL
- Environment Variables
- Health Check
- Swagger UI
- ReDoc

---

# Learning Outcomes

This project demonstrates practical experience with:

- FastAPI
- SQLAlchemy ORM
- PostgreSQL
- JWT Authentication
- REST API Design
- Docker
- Clean Architecture
- Dependency Injection
- Automated Testing
- API Documentation

---

# Contributing

Contributions are welcome.

If you would like to improve this project:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Open a Pull Request.

---

# License

This project is intended for educational, portfolio, and evaluation purposes.

You may modify and extend it for your own learning or personal projects.

---

# Acknowledgements

This project was built using the following open-source technologies:

- FastAPI
- SQLAlchemy
- PostgreSQL
- Pydantic
- Passlib
- bcrypt
- Pytest
- Docker

Special thanks to the maintainers and contributors of these projects for providing excellent tools and documentation.

---

# Final Status

## Completed Features

- User Registration
- User Login
- JWT Authentication
- Role-Based Access Control (RBAC)
- Current User Endpoint
- Notes CRUD Operations
- Pagination
- Partial Update (PATCH)
- PostgreSQL Integration
- SQLAlchemy 2.x
- Pydantic V2
- Docker Support
- Swagger Documentation
- ReDoc Documentation
- Automated Testing
- Clean Architecture
- Enterprise Folder Structure
- Flutter-ready REST API

---

## Project Status

**Version:** `1.0.0`

**Status:** Production Ready

**Architecture:** Clean Architecture

**API Style:** RESTful

**Authentication:** JWT

**Database:** PostgreSQL

**Testing:** Pytest

**Containerization:** Docker

**Documentation:** Swagger + ReDoc

**Client Support:**

- ✅ Flutter
- ✅ Next.js
- ✅ REST Clients
- ✅ Postman

---