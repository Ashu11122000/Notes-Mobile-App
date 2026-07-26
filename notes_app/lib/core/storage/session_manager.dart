import 'package:flutter/foundation.dart';

import '../constants/storage_constants.dart';
import 'shared_preferences_service.dart';

/// ============================================================================
/// File: session_manager.dart
/// ============================================================================
///
/// Manages the user's local authentication session.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Persists authentication data.
/// • Retrieves authentication data.
/// • Clears the current session.
/// • Exposes lightweight authentication state helpers.
///
/// This class intentionally does NOT:
/// • Authenticate users.
/// • Refresh tokens.
/// • Perform API requests.
/// • Navigate between screens.
///
/// Those responsibilities belong to repositories and higher application layers.
///
/// All values are stored using [SharedPreferencesService].
/// ============================================================================
@immutable
final class SessionManager {
  const SessionManager._();

  // ===========================================================================
  // Access Token
  // ===========================================================================

  /// Persists the JWT access token.
  static Future<bool> saveAccessToken(String token) async {
    await SharedPreferencesService.setBool(StorageConstants.isLoggedIn, true);

    return SharedPreferencesService.setString(
      StorageConstants.accessToken,
      token,
    );
  }

  /// Returns the stored JWT access token.
  static String? getAccessToken() {
    return SharedPreferencesService.getString(StorageConstants.accessToken);
  }

  /// Returns whether an access token exists.
  static bool get hasAccessToken {
    final token = getAccessToken();

    return token != null && token.isNotEmpty;
  }

  /// Removes the stored JWT access token.
  static Future<bool> removeAccessToken() {
    return SharedPreferencesService.remove(StorageConstants.accessToken);
  }

  // ===========================================================================
  // Refresh Token
  // ===========================================================================

  /// Persists the refresh token.
  ///
  /// Reserved for future backend support.
  static Future<bool> saveRefreshToken(String token) {
    return SharedPreferencesService.setString(
      StorageConstants.refreshToken,
      token,
    );
  }

  /// Returns the stored refresh token.
  static String? getRefreshToken() {
    return SharedPreferencesService.getString(StorageConstants.refreshToken);
  }

  /// Removes the stored refresh token.
  static Future<bool> removeRefreshToken() {
    return SharedPreferencesService.remove(StorageConstants.refreshToken);
  }

  // ===========================================================================
  // Session
  // ===========================================================================

  /// Returns whether the user is currently authenticated.
  static bool isLoggedIn() {
    return SharedPreferencesService.getBool(StorageConstants.isLoggedIn) ??
        hasAccessToken;
  }

  /// Persists the login state.
  static Future<bool> setLoggedIn(bool value) {
    return SharedPreferencesService.setBool(StorageConstants.isLoggedIn, value);
  }

  /// Clears the current session.
  static Future<bool> clearSession() async {
    await Future.wait([
      SharedPreferencesService.remove(StorageConstants.accessToken),
      SharedPreferencesService.remove(StorageConstants.refreshToken),
      SharedPreferencesService.remove(StorageConstants.isLoggedIn),
    ]);

    return true;
  }
}
