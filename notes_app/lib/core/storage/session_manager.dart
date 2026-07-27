import 'package:flutter/foundation.dart';

import '../constants/storage_constants.dart';
import '../services/logger_service.dart';
import 'shared_preferences_service.dart';

/// ============================================================================
/// File: session_manager.dart
/// ============================================================================
///
/// Enterprise Session Manager
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Stores authentication session.
/// • Retrieves authentication session.
/// • Clears authentication session.
/// • Provides authentication helpers.
/// • Produces detailed debug logs.
/// • Verifies persistence after every write.
/// ============================================================================
@immutable
final class SessionManager {
  const SessionManager._();

  // ===========================================================================
  // Access Token
  // ===========================================================================

  static Future<bool> saveAccessToken(String token) async {
    final String cleanToken = token.trim();

    // Reject empty tokens and ensure no stale session remains.
    if (cleanToken.isEmpty) {
      LoggerService.warning('Attempted to save an empty access token.');

      await SharedPreferencesService.remove(StorageConstants.accessToken);
      await SharedPreferencesService.remove(StorageConstants.isLoggedIn);

      return false;
    }

    try {
      final bool saved = await SharedPreferencesService.setString(
        StorageConstants.accessToken,
        cleanToken,
      );

      if (!saved) {
        LoggerService.error('SharedPreferences failed to save access token.');
        return false;
      }

      await SharedPreferencesService.setBool(StorageConstants.isLoggedIn, true);

      final String? storedToken = SharedPreferencesService.getString(
        StorageConstants.accessToken,
      );

      if (storedToken == null || storedToken != cleanToken) {
        LoggerService.error('Token verification failed after saving.');
        return false;
      }

      LoggerService.info('''
================ SESSION SAVED ================

Access Token Saved : YES

Length             : ${cleanToken.length}

Preview            :
${cleanToken.substring(0, cleanToken.length > 25 ? 25 : cleanToken.length)}...

Logged In Flag     :
${SharedPreferencesService.getBool(StorageConstants.isLoggedIn)}

==============================================
''');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to save access token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  static String? getAccessToken() {
    try {
      final String? token = SharedPreferencesService.getString(
        StorageConstants.accessToken,
      );

      if (kDebugMode) {
        LoggerService.info('''
================ TOKEN READ ===================

Token Exists :
${token != null}

Length :
${token?.length ?? 0}

Preview :
${token == null ? 'NULL' : '${token.substring(0, token.length > 25 ? 25 : token.length)}...'}

==============================================
''');
      }

      final String? trimmed = token?.trim();

      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }

      return trimmed;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to read access token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  static bool get hasAccessToken {
    final String? token = getAccessToken();
    return token != null;
  }

  static Future<bool> removeAccessToken() async {
    try {
      await SharedPreferencesService.remove(StorageConstants.accessToken);

      await SharedPreferencesService.remove(StorageConstants.isLoggedIn);

      LoggerService.info('Access token removed.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to remove access token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Refresh Token
  // ===========================================================================

  static Future<bool> saveRefreshToken(String token) async {
    final String cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      LoggerService.warning('Attempted to save an empty refresh token.');
      return false;
    }

    try {
      return await SharedPreferencesService.setString(
        StorageConstants.refreshToken,
        cleanToken,
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to save refresh token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  static String? getRefreshToken() {
    try {
      final String? token = SharedPreferencesService.getString(
        StorageConstants.refreshToken,
      );

      final String? trimmed = token?.trim();

      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }

      return trimmed;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to read refresh token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  static Future<bool> removeRefreshToken() async {
    try {
      return await SharedPreferencesService.remove(
        StorageConstants.refreshToken,
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to remove refresh token.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static bool isLoggedIn() {
    return hasAccessToken;
  }

  static Future<bool> setLoggedIn(bool value) {
    return SharedPreferencesService.setBool(StorageConstants.isLoggedIn, value);
  }

  // ===========================================================================
  // Session
  // ===========================================================================

  static Future<bool> clearSession() async {
    try {
      await Future.wait([
        SharedPreferencesService.remove(StorageConstants.accessToken),
        SharedPreferencesService.remove(StorageConstants.refreshToken),
        SharedPreferencesService.remove(StorageConstants.isLoggedIn),
      ]);

      LoggerService.warning('''
================ SESSION CLEARED ==============

Access Token : REMOVED

Refresh Token : REMOVED

Logged In Flag : REMOVED

==============================================
''');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to clear session.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  static void debugSession() {
    if (!kDebugMode) {
      return;
    }

    final String? token = getAccessToken();

    LoggerService.info('''
================ SESSION DEBUG ================

Has Token:
${token != null}

Token Length:
${token?.length ?? 0}

Token Preview:
${token == null ? 'NULL' : '${token.substring(0, token.length > 30 ? 30 : token.length)}...'}

Logged In:
${isLoggedIn()}

Stored Keys:
${SharedPreferencesService.getKeys()}

==============================================
''');
  }
}
