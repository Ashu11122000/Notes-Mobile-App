import 'package:flutter/foundation.dart';

import '../constants/storage_constants.dart';
import '../services/logger_service.dart';
import 'secure_storage_service.dart';
import 'shared_preferences_service.dart';

/// ============================================================================
/// File: session_manager.dart
/// ============================================================================
///
/// Enterprise Session Manager
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Securely stores authentication tokens.
/// • Retrieves authentication tokens.
/// • Manages authentication state.
/// • Clears authentication session.
/// • Provides lightweight helper methods.
/// • Never logs sensitive JWT values.
/// ============================================================================

@immutable
final class SessionManager {
  const SessionManager._();

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  static Future<bool> _saveSecureValue({
    required String key,
    required String value,
    required String label,
  }) async {
    final String cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      LoggerService.warning('Attempted to save an empty $label.');
      return false;
    }

    try {
      await SecureStorageService.write(key: key, value: cleanValue);

      final String? storedValue = await SecureStorageService.read(key: key);

      if (storedValue != cleanValue) {
        LoggerService.error('$label verification failed.');
        return false;
      }

      LoggerService.info('$label stored successfully.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to save $label.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  static Future<String?> _readSecureValue({
    required String key,
    required String label,
  }) async {
    try {
      final String? value = await SecureStorageService.read(key: key);

      final String? trimmed = value?.trim();

      if (trimmed == null || trimmed.isEmpty) {
        return null;
      }

      return trimmed;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to read $label.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  static Future<bool> _removeSecureValue({
    required String key,
    required String label,
  }) async {
    try {
      await SecureStorageService.delete(key: key);

      LoggerService.info('$label removed.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to remove $label.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Access Token
  // ===========================================================================

  static Future<bool> saveAccessToken(String token) async {
    final bool saved = await _saveSecureValue(
      key: StorageConstants.accessToken,
      value: token,
      label: 'Access token',
    );

    if (!saved) {
      await SharedPreferencesService.remove(StorageConstants.isLoggedIn);

      return false;
    }

    await SharedPreferencesService.setBool(StorageConstants.isLoggedIn, true);

    return true;
  }

  static Future<String?> getAccessToken() {
    return _readSecureValue(
      key: StorageConstants.accessToken,
      label: 'Access token',
    );
  }

  static Future<bool> hasAccessToken() async {
    return (await getAccessToken()) != null;
  }

  static Future<bool> removeAccessToken() async {
    final bool removed = await _removeSecureValue(
      key: StorageConstants.accessToken,
      label: 'Access token',
    );

    if (removed) {
      await SharedPreferencesService.remove(StorageConstants.isLoggedIn);
    }

    return removed;
  }

  // ===========================================================================
  // Refresh Token
  // ===========================================================================

  static Future<bool> saveRefreshToken(String token) {
    return _saveSecureValue(
      key: StorageConstants.refreshToken,
      value: token,
      label: 'Refresh token',
    );
  }

  static Future<String?> getRefreshToken() {
    return _readSecureValue(
      key: StorageConstants.refreshToken,
      label: 'Refresh token',
    );
  }

  static Future<bool> hasRefreshToken() async {
    return (await getRefreshToken()) != null;
  }

  static Future<bool> removeRefreshToken() {
    return _removeSecureValue(
      key: StorageConstants.refreshToken,
      label: 'Refresh token',
    );
  }

  // ===========================================================================
  // Authentication
  // ===========================================================================

  /// Returns whether the user currently has a valid local session.
  static Future<bool> isLoggedIn() async {
    final bool loggedIn =
        SharedPreferencesService.getBool(StorageConstants.isLoggedIn) ?? false;

    if (!loggedIn) {
      return false;
    }

    return hasAccessToken();
  }

  /// Updates the lightweight login flag.
  static Future<bool> setLoggedIn(bool value) {
    return SharedPreferencesService.setBool(StorageConstants.isLoggedIn, value);
  }

  // ===========================================================================
  // Session
  // ===========================================================================

  /// Clears the complete authentication session.
  static Future<bool> clearSession() async {
    try {
      await Future.wait<void>([
        SecureStorageService.delete(key: StorageConstants.accessToken),
        SecureStorageService.delete(key: StorageConstants.refreshToken),
        SharedPreferencesService.remove(StorageConstants.isLoggedIn),
      ]);

      LoggerService.info('Authentication session cleared successfully.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to clear authentication session.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  /// Logs non-sensitive session information.
  ///
  /// Security:
  /// • Never logs access tokens.
  /// • Never logs refresh tokens.
  /// • Never logs JWT payloads.
  /// • Never logs token previews.
  ///
  /// Intended for development diagnostics only.
  static Future<void> debugSession() async {
    if (!kDebugMode) {
      return;
    }

    try {
      final bool hasAccess = await hasAccessToken();
      final bool hasRefresh = await hasRefreshToken();

      final bool loggedIn =
          SharedPreferencesService.getBool(StorageConstants.isLoggedIn) ??
          false;

      LoggerService.info('''
================ SESSION DEBUG ================

Authenticated      : $loggedIn

Access Token       : ${hasAccess ? 'Available' : 'Missing'}

Refresh Token      : ${hasRefresh ? 'Available' : 'Missing'}

Preference Keys    :
${SharedPreferencesService.getKeys()}

==============================================
''');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to debug session.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Convenience Helpers
  // ===========================================================================

  /// Saves the complete authentication session.
  static Future<bool> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    final bool accessSaved = await saveAccessToken(accessToken);

    if (!accessSaved) {
      return false;
    }

    final bool refreshSaved = await saveRefreshToken(refreshToken);

    if (!refreshSaved) {
      await removeAccessToken();
      return false;
    }

    await setLoggedIn(true);

    return true;
  }

  /// Returns true only if both tokens are available.
  static Future<bool> hasValidSession() async {
    final bool access = await hasAccessToken();
    final bool refresh = await hasRefreshToken();

    return access && refresh;
  }
}
