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
/// • Exposes current ThemeMode.
/// • Handles settings initialization.
/// • Contains no UI logic.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Manage authentication.
/// • Manage notifications.
/// • Access widgets.
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

  // ===========================================================================
  // Storage Keys
  // ===========================================================================

  static const String _themeModeKey = 'theme_mode';

  // ===========================================================================
  // State
  // ===========================================================================

  ThemeMode _themeMode = ThemeMode.system;

  bool _initialized = false;

  bool _isLoading = false;

  // ===========================================================================
  // Getters
  // ===========================================================================

  ThemeMode get themeMode => _themeMode;

  bool get initialized => _initialized;

  bool get isLoading => _isLoading;

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

    try {
      _setLoading(true);

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final String? storedMode = preferences.getString(_themeModeKey);

      _themeMode = _fromStorageValue(storedMode);

      _initialized = true;

      LoggerService.info('SettingsProvider initialized.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize settings.',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Theme Update
  // ===========================================================================

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    try {
      _setLoading(true);

      _themeMode = mode;

      notifyListeners();

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setString(_themeModeKey, _toStorageValue(mode));

      LoggerService.info('Theme changed: ${mode.name}');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update theme mode.',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Reset Settings
  // ===========================================================================

  Future<void> reset() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.remove(_themeModeKey);

      _themeMode = ThemeMode.system;

      notifyListeners();

      LoggerService.info('Settings reset successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to reset settings.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Serialization Helpers
  // ===========================================================================

  String _toStorageValue(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';

      case ThemeMode.dark:
        return 'dark';

      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _fromStorageValue(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // ===========================================================================
  // Loading Helper
  // ===========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  @override
  void dispose() {
    LoggerService.info('SettingsProvider disposed.');

    super.dispose();
  }
}
