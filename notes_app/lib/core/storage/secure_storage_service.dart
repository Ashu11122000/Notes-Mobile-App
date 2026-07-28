import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ============================================================================
/// File: secure_storage_service.dart
/// ============================================================================
///
/// Enterprise Secure Storage Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Stores sensitive application data securely.
/// • Centralizes FlutterSecureStorage access.
/// • Provides a lightweight, strongly typed API.
/// • Prevents direct dependency on FlutterSecureStorage.
/// • Supports future dependency injection and testing.
///
/// Store only:
/// • Access Token
/// • Refresh Token
/// • API Keys (if required)
///
/// Never store:
/// • Theme
/// • Language
/// • Preferences
/// • Filters
/// • Sort options
/// • UI settings
/// ============================================================================
@immutable
final class SecureStorageService {
  const SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ===========================================================================
  // Write
  // ===========================================================================

  /// Writes a secure value.
  static Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  /// Backward-compatible alias.
  static Future<void> writeString({
    required String key,
    required String value,
  }) {
    return write(key: key, value: value);
  }

  // ===========================================================================
  // Read
  // ===========================================================================

  /// Reads a secure value.
  static Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  /// Backward-compatible alias.
  static Future<String?> readString(String key) {
    return read(key: key);
  }

  // ===========================================================================
  // Exists
  // ===========================================================================

  /// Returns true if the key exists.
  static Future<bool> containsKey({required String key}) {
    return _storage.containsKey(key: key);
  }

  // ===========================================================================
  // Delete
  // ===========================================================================

  /// Deletes a secure value.
  static Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  /// Backward-compatible alias.
  static Future<void> remove(String key) {
    return delete(key: key);
  }

  // ===========================================================================
  // Delete Multiple
  // ===========================================================================

  /// Deletes multiple secure values.
  static Future<void> removeAll(Iterable<String> keys) async {
    for (final key in keys) {
      await delete(key: key);
    }
  }

  // ===========================================================================
  // Read All
  // ===========================================================================

  /// Reads all secure values.
  static Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  // ===========================================================================
  // Clear
  // ===========================================================================

  /// Removes every secure value.
  static Future<void> clear() {
    return _storage.deleteAll();
  }
}
