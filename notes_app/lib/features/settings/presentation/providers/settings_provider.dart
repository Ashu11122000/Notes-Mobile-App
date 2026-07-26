import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/logger_service.dart';

/// ============================================================================
/// File: settings_provider.dart
/// ============================================================================
///
/// Settings Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages application settings.
/// • Persists theme preference locally.
/// • Exposes current theme mode.
/// • Contains no UI logic.
/// • Does NOT manage authentication.
/// • Does NOT manage notifications.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// SettingsProvider
///     ↓
/// SharedPreferences
///
/// ============================================================================

final class SettingsProvider extends ChangeNotifier {
  SettingsProvider();

  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  bool _initialized = false;

  // ===========================================================================
  // Getters
  // ===========================================================================

  ThemeMode get themeMode => _themeMode;

  bool get initialized => _initialized;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get isLightMode => _themeMode == ThemeMode.light;

  bool get isSystemMode => _themeMode == ThemeMode.system;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? value = preferences.getString(_themeModeKey);

    switch (value) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;

      case 'dark':
        _themeMode = ThemeMode.dark;
        break;

      default:
        _themeMode = ThemeMode.system;
    }

    _initialized = true;

    notifyListeners();

    LoggerService.info('SettingsProvider initialized.');
  }

  // ===========================================================================
  // Theme
  // ===========================================================================

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;

    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String value = 'system';

    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;

      case ThemeMode.dark:
        value = 'dark';
        break;

      case ThemeMode.system:
        value = 'system';
        break;
    }

    await preferences.setString(_themeModeKey, value);

    LoggerService.info('Theme changed to $value.');
  }

  // ===========================================================================
  // Reset
  // ===========================================================================

  Future<void> reset() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.remove(_themeModeKey);

    _themeMode = ThemeMode.system;

    notifyListeners();

    LoggerService.info('Settings reset.');
  }
}
