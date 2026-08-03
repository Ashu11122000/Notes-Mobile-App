/// ============================================================================
/// File: test/mocks/mock_auth_repository.dart
/// ============================================================================
///
/// Mock Authentication Repository
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Provides a reusable mock implementation of [AuthRepository].
/// • Used by unit tests, provider tests, widget tests and integration tests.
/// • Intentionally contains no fake request models because the application's
///   request DTOs are declared as `final class`.
///
/// Notes
/// ----------------------------------------------------------------------------
/// When stubbing methods like:
///
///   repository.login(...)
///   repository.register(...)
///
/// create real request model instances instead of using `any()`.
///
/// Example:
///
/// final request = LoginRequestModel(
///   email: 'john@example.com',
///   password: 'Password@123',
/// );
///
/// when(
///   () => repository.login(request),
/// ).thenAnswer(
///   (_) async => MockData.loginResponse,
/// );
///
/// ============================================================================

import 'package:mocktail/mocktail.dart';

import 'package:notes_app/features/auth/data/repositories/auth_repository.dart';

/// Mock implementation of [AuthRepository].
class MockAuthRepository extends Mock implements AuthRepository {}
