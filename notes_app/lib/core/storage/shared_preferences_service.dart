import 'package:shared_preferences/shared_preferences.dart';

/// Centralized wrapper around SharedPreferences.
///
/// This service is the single entry point for reading and writing
/// local key-value data throughout the application.
///
/// Features should never access SharedPreferences directly.
final class SharedPreferencesService {
  SharedPreferencesService._();

  static late SharedPreferences _preferences;

  /// Initializes SharedPreferences.
  ///
  /// Must be called before accessing the service.
  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Returns the underlying SharedPreferences instance.
  static SharedPreferences get instance => _preferences;

  // ===========================================================================
  // String
  // ===========================================================================

  static Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  // ===========================================================================
  // Bool
  // ===========================================================================

  static Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  // ===========================================================================
  // Int
  // ===========================================================================

  static Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  // ===========================================================================
  // Double
  // ===========================================================================

  static Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  // ===========================================================================
  // String List
  // ===========================================================================

  static Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  // ===========================================================================
  // Generic
  // ===========================================================================

  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  static Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  static Future<bool> clear() {
    return _preferences.clear();
  }

  static Future<void> reload() {
    return _preferences.reload();
  }
}
