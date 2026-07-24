/// Represents the supported application theme modes.
///
/// This enum is intended to be used by the future Settings feature for
/// persisting and restoring the user's preferred theme.
///
/// Example:
/// ```dart
/// AppTheme.system.nameValue; // system
/// AppTheme.dark.displayName; // Dark
/// ```
enum AppTheme {
  /// Follow the device's system theme.
  system(nameValue: 'system', displayName: 'System'),

  /// Always use the light theme.
  light(nameValue: 'light', displayName: 'Light'),

  /// Always use the dark theme.
  dark(nameValue: 'dark', displayName: 'Dark');

  /// Creates an application theme.
  const AppTheme({required this.nameValue, required this.displayName});

  /// Value stored in SharedPreferences.
  final String nameValue;

  /// Human-readable theme name.
  final String displayName;

  /// Returns an [AppTheme] from a stored value.
  ///
  /// Defaults to [AppTheme.system] if the value is null or invalid.
  static AppTheme fromValue(String? value) {
    return AppTheme.values.firstWhere(
      (theme) => theme.nameValue == value,
      orElse: () => AppTheme.system,
    );
  }
}
