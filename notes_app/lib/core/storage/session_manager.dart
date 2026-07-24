
import 'package:notes_app/core/storage/shared_preferences_service.dart';

import '../constants/storage_constants.dart';

/// Manages the user's local session.
///
/// This class is responsible for persisting and retrieving
/// authentication-related data.
///
/// It does NOT perform authentication requests.
/// Those belong to the AuthRepository.
final class SessionManager {
  const SessionManager._();

  // ===========================================================================
  // Access Token
  // ===========================================================================

  /// Saves the JWT access token.
  static Future<bool> saveAccessToken(String token) {
    return SharedPreferencesService.setString(
      StorageConstants.accessToken,
      token,
    );
  }

  /// Returns the stored JWT access token.
  static String? getAccessToken() {
    return SharedPreferencesService.getString(StorageConstants.accessToken);
  }

  /// Removes the stored JWT access token.
  static Future<bool> removeAccessToken() {
    return SharedPreferencesService.remove(StorageConstants.accessToken);
  }

  // ===========================================================================
  // Session
  // ===========================================================================

  /// Returns true if an access token exists.
  static bool isLoggedIn() {
    final token = getAccessToken();

    return token != null && token.isNotEmpty;
  }

  /// Clears the current user session.
  static Future<bool> clearSession() async {
    await removeAccessToken();

    return true;
  }
}
