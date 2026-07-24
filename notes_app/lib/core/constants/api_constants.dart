/// Centralized API constants.
///
/// This class contains API-related constants that are shared across
/// the application. Environment-specific values (such as the base URL)
/// should be managed separately through configuration.
final class ApiConstants {
  const ApiConstants._();

  // ===========================================================================
  // API Version
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

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String register = '$apiVersion/auth/register';

  static const String login = '$apiVersion/auth/login';

  static const String currentUser = '$apiVersion/auth/me';

  // ===========================================================================
  // Notes
  // ===========================================================================

  static const String notes = '$apiVersion/notes';

  // ===========================================================================
  // Health
  // ===========================================================================

  static const String health = '/health';
}
