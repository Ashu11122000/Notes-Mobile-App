// ============================================================================
// File: api_constants.dart
// ============================================================================
//
// Centralized API constants.
//
// Responsibilities
// ----------------------------------------------------------------------------
// - Defines API endpoints.
// - Defines HTTP headers.
// - Defines timeout values.
// - Provides helper methods for dynamic endpoints.
// - Keeps API-related constants in a single location.
//
// Environment-specific values (such as the base URL) should be managed
// separately through configuration.
//
// ============================================================================

final class ApiConstants {
  const ApiConstants._();

  // ===========================================================================
  // API
  // ===========================================================================

  static const String apiVersion = '/api/v1';

  // ===========================================================================
  // Timeouts
  // ===========================================================================

  static const Duration connectTimeout = Duration(seconds: 30);

  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Duration sendTimeout = Duration(seconds: 30);

  // ===========================================================================
  // Headers
  // ===========================================================================

  static const String authorizationHeader = 'Authorization';

  static const String contentTypeHeader = 'Content-Type';

  static const String acceptHeader = 'Accept';

  static const String applicationJson = 'application/json';

  static const String bearerPrefix = 'Bearer';

  static const String bearerTokenPrefix = '$bearerPrefix ';

  // ===========================================================================
  // Authentication Endpoints
  // ===========================================================================

  static const String register = '$apiVersion/auth/register';

  static const String login = '$apiVersion/auth/login';

  static const String currentUser = '$apiVersion/auth/me';

  // ===========================================================================
  // Notes Endpoints
  // ===========================================================================

  /// Collection endpoint.
  static const String notes = '$apiVersion/notes';

  /// Returns the endpoint for a specific note.
  static String noteById(int noteId) => '$notes/$noteId';

  // ===========================================================================
  // Health
  // ===========================================================================

  static const String health = '/health';
}
