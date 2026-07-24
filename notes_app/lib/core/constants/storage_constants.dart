/// Centralized keys used for local storage.
///
/// Never hardcode SharedPreferences keys throughout the application.
/// Define all keys here to keep them consistent and easy to maintain.
final class StorageConstants {
  const StorageConstants._();

  // ===========================================================================
  // Authentication
  // ===========================================================================

  /// JWT access token.
  static const String accessToken = 'access_token';

  // ===========================================================================
  // User
  // ===========================================================================

  /// Logged-in user information (reserved for future use).
  static const String currentUser = 'current_user';

  // ===========================================================================
  // App Settings
  // ===========================================================================

  /// Theme mode (reserved for future use).
  static const String themeMode = 'theme_mode';

  /// First launch flag (reserved for future use).
  static const String isFirstLaunch = 'is_first_launch';
}
