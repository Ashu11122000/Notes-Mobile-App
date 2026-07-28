import 'package:flutter/material.dart';

/// =============================================================================
/// File: app_theme.dart
/// =============================================================================
///
/// Defines the theme modes supported by the Notes App.
///
/// This enum acts as the single source of truth for persisted theme values
/// and their integration with Flutter's [ThemeMode].
///
/// It is intentionally lightweight, strongly typed, and easy to extend.
///
/// Example:
/// ```dart
/// final theme = AppTheme.fromValue('dark');
///
/// print(theme.displayName); // Dark
/// print(theme.nameValue);   // dark
/// print(theme.themeMode);   // ThemeMode.dark
/// ```
enum AppTheme {
  /// Follow the operating system theme.
  system(nameValue: 'system', displayName: 'System'),

  /// Always use the light theme.
  light(nameValue: 'light', displayName: 'Light'),

  /// Always use the dark theme.
  dark(nameValue: 'dark', displayName: 'Dark');

  const AppTheme({required this.nameValue, required this.displayName});

  /// Value persisted in local storage.
  final String nameValue;

  /// User-visible theme name.
  ///
  /// Note: When localization is introduced, UI should provide localized
  /// strings while this enum continues to expose stable identifiers.
  final String displayName;

  /// Corresponding Flutter [ThemeMode].
  ThemeMode get themeMode => switch (this) {
    AppTheme.system => ThemeMode.system,
    AppTheme.light => ThemeMode.light,
    AppTheme.dark => ThemeMode.dark,
  };

  /// Whether this is the default application theme.
  bool get isDefault => this == AppTheme.system;

  /// Converts a persisted value into an [AppTheme].
  ///
  /// Supported examples:
  /// - system
  /// - light
  /// - dark
  ///
  /// Returns [AppTheme.system] for null, empty, or unsupported values.
  static AppTheme fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return AppTheme.system;
    }

    return values.firstWhere(
      (theme) => theme.nameValue == normalized,
      orElse: () => AppTheme.system,
    );
  }

  /// Converts Flutter's [ThemeMode] into an [AppTheme].
  static AppTheme fromThemeMode(ThemeMode mode) => switch (mode) {
    ThemeMode.system => AppTheme.system,
    ThemeMode.light => AppTheme.light,
    ThemeMode.dark => AppTheme.dark,
  };

  /// Returns whether a persisted theme value is supported.
  static bool isSupported(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return values.any((theme) => theme.nameValue == normalized);
  }

  /// Returns the display name for a persisted value.
  static String displayNameOf(String? value) => fromValue(value).displayName;

  /// Supported persisted theme values.
  static List<String> get supportedValues =>
      values.map((e) => e.nameValue).toList(growable: false);
}
