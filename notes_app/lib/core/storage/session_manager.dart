import 'package:flutter/foundation.dart';

import '../constants/storage_constants.dart';
import '../services/logger_service.dart';
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
/// • Clears current session.
/// • Exposes lightweight authentication helpers.
///
/// This class does NOT:
/// • Authenticate users.
/// • Perform API requests.
/// • Refresh tokens.
/// • Navigate screens.
///
/// All storage operations are handled through SharedPreferencesService.
///
/// ============================================================================

@immutable
final class SessionManager {
  const SessionManager._();

  // ===========================================================================
  // Access Token
  // ===========================================================================

  /// Saves JWT access token locally.
  ///
  /// Token is trimmed before storage to prevent invalid Authorization headers.
  static Future<bool> saveAccessToken(String token) async {
    final String cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      LoggerService.warning('Attempted to save empty access token.');

      return false;
    }

    await SharedPreferencesService.setBool(StorageConstants.isLoggedIn, true);

    final bool saved = await SharedPreferencesService.setString(
      StorageConstants.accessToken,
      cleanToken,
    );

    if (saved) {
      LoggerService.info('Access token saved successfully.');
    }

    return saved;
  }

  /// Returns stored JWT access token.
  static String? getAccessToken() {
    final String? token = SharedPreferencesService.getString(
      StorageConstants.accessToken,
    );

    return token?.trim();
  }

  /// Returns true if a valid access token exists.
  static bool get hasAccessToken {
    final String? token = getAccessToken();

    return token != null && token.isNotEmpty;
  }

  /// Removes access token.
  static Future<bool> removeAccessToken() {
    return SharedPreferencesService.remove(StorageConstants.accessToken);
  }

  // ===========================================================================
  // Refresh Token
  // ===========================================================================

  /// Saves refresh token.
  ///
  /// Reserved for future backend refresh-token support.
  static Future<bool> saveRefreshToken(String token) {
    return SharedPreferencesService.setString(
      StorageConstants.refreshToken,
      token.trim(),
    );
  }

  /// Returns refresh token.
  static String? getRefreshToken() {
    return SharedPreferencesService.getString(StorageConstants.refreshToken);
  }

  /// Removes refresh token.
  static Future<bool> removeRefreshToken() {
    return SharedPreferencesService.remove(StorageConstants.refreshToken);
  }

  // ===========================================================================
  // Authentication State
  // ===========================================================================

  /// Returns whether user session is valid.
  ///
  /// Token presence is the source of truth.
  /// We do not trust the stored boolean flag alone.
  static bool isLoggedIn() {
    return hasAccessToken;
  }

  /// Updates login flag.
  ///
  /// Mainly kept for compatibility.
  static Future<bool> setLoggedIn(bool value) {
    return SharedPreferencesService.setBool(StorageConstants.isLoggedIn, value);
  }

  // ===========================================================================
  // Session Management
  // ===========================================================================

  /// Clears complete user session.
  static Future<bool> clearSession() async {
    try {
      await Future.wait([
        SharedPreferencesService.remove(StorageConstants.accessToken),

        SharedPreferencesService.remove(StorageConstants.refreshToken),

        SharedPreferencesService.remove(StorageConstants.isLoggedIn),
      ]);

      LoggerService.info('User session cleared successfully.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to clear user session.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Debug Helpers
  // ===========================================================================

  /// Prints current session status.
  static void debugSession() {
    if (!kDebugMode) {
      return;
    }

    final String? token = getAccessToken();

    debugPrint('''
================ Session Debug ================

Has Token:
${token != null && token.isNotEmpty}

Token Preview:
${token == null ? 'null' : '${token.substring(0, token.length > 20 ? 20 : token.length)}...'}

Logged In:
${isLoggedIn()}

===============================================
''');
  }
}
