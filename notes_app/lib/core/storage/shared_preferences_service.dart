import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// File: shared_preferences_service.dart
/// ============================================================================
///
/// Enterprise SharedPreferences service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Centralizes access to SharedPreferences.
/// • Prevents direct SharedPreferences usage throughout the application.
/// • Provides strongly typed read/write helpers.
/// • Ensures a single initialized instance.
///
/// This service intentionally contains no business logic.
///
/// Features should interact with local storage only through this service.
///
/// Testing
/// ----------------------------------------------------------------------------
/// • Provides [resetForTesting] to allow unit tests to reset the singleton.
/// • Has no impact on production behavior.
/// ============================================================================
@immutable
final class SharedPreferencesService {
  const SharedPreferencesService._();

  static SharedPreferences? _preferences;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  /// Initializes SharedPreferences.
  ///
  /// Safe to call multiple times.
  static Future<void> initialize() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Returns whether the service has been initialized.
  static bool get isInitialized => _preferences != null;

  /// Returns the shared SharedPreferences instance.
  ///
  /// Throws a descriptive error if initialization was forgotten.
  static SharedPreferences get instance {
    final SharedPreferences? preferences = _preferences;

    if (preferences == null) {
      throw StateError(
        'SharedPreferencesService has not been initialized.\n'
        'Call SharedPreferencesService.initialize() before use.',
      );
    }

    return preferences;
  }

  // ===========================================================================
  // Testing
  // ===========================================================================

  /// Resets the cached SharedPreferences instance.
  ///
  /// This method exists ONLY to support unit and widget tests.
  ///
  /// Production code should never call this method.
  @visibleForTesting
  static void resetForTesting() {
    _preferences = null;
  }

  // ===========================================================================
  // String
  // ===========================================================================

  static Future<bool> setString(String key, String value) {
    return instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  // ===========================================================================
  // Bool
  // ===========================================================================

  static Future<bool> setBool(String key, bool value) {
    return instance.setBool(key, value);
  }

  static bool? getBool(String key) {
    return instance.getBool(key);
  }

  // ===========================================================================
  // Integer
  // ===========================================================================

  static Future<bool> setInt(String key, int value) {
    return instance.setInt(key, value);
  }

  static int? getInt(String key) {
    return instance.getInt(key);
  }

  // ===========================================================================
  // Double
  // ===========================================================================

  static Future<bool> setDouble(String key, double value) {
    return instance.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return instance.getDouble(key);
  }

  // ===========================================================================
  // String List
  // ===========================================================================

  static Future<bool> setStringList(String key, List<String> value) {
    return instance.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return instance.getStringList(key);
  }

  // ===========================================================================
  // Generic
  // ===========================================================================

  /// Stores a supported value type.
  ///
  /// Supported types:
  /// • String
  /// • bool
  /// • int
  /// • double
  /// • List<String>
  static Future<bool> setValue(String key, Object value) {
    switch (value) {
      case String():
        return instance.setString(key, value);

      case bool():
        return instance.setBool(key, value);

      case int():
        return instance.setInt(key, value);

      case double():
        return instance.setDouble(key, value);

      case List<String>():
        return instance.setStringList(key, value);

      default:
        throw ArgumentError(
          'Unsupported SharedPreferences value type: ${value.runtimeType}',
        );
    }
  }

  /// Stores a value only if the key does not already exist.
  static Future<bool> setIfAbsent(String key, Object value) async {
    if (containsKey(key)) {
      return true;
    }

    return setValue(key, value);
  }

  /// Returns whether a key exists.
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  /// Returns all stored keys.
  static Set<String> getKeys() {
    return instance.getKeys();
  }

  /// Removes a single key.
  static Future<bool> remove(String key) {
    return instance.remove(key);
  }

  /// Clears all stored values.
  static Future<bool> clear() {
    return instance.clear();
  }

  /// Reloads values from disk.
  static Future<void> reload() {
    return instance.reload();
  }
}
