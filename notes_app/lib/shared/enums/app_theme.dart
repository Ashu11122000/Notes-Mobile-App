/// =============================================================================
/// File: app_theme.dart
/// =============================================================================
///
/// Defines the theme modes supported by the Notes App.
///
/// This enum serves as the single source of truth for theme-related metadata.
/// It is intentionally lightweight and designed to integrate seamlessly with
/// Flutter's Material 3 theming and future Settings functionality.
///
/// Typical usage:
///
/// - Persisting the user's preferred theme.
/// - Restoring the theme during app startup.
/// - Displaying user-friendly names in the Settings screen.
/// - Converting stored values into strongly typed enums.
///
/// Example:
/// ```dart
/// final theme = AppTheme.fromValue('dark');
///
/// print(theme.displayName);   // Dark
/// print(theme.nameValue);     // dark
/// print(theme.themeModeName); // dark
/// ```
enum AppTheme {
  /// Follow the operating system's current theme.
  system(nameValue: 'system', displayName: 'System'),

  /// Always use the light appearance.
  light(nameValue: 'light', displayName: 'Light'),

  /// Always use the dark appearance.
  dark(nameValue: 'dark', displayName: 'Dark');

  /// Creates an application theme.
  const AppTheme({required this.nameValue, required this.displayName});

  /// Value persisted in local storage.
  ///
  /// Examples:
  /// - `system`
  /// - `light`
  /// - `dark`
  final String nameValue;

  /// Human-readable theme name displayed in the UI.
  final String displayName;

  /// Canonical theme identifier.
  ///
  /// This getter improves readability when integrating with future
  /// theming or analytics services.
  String get themeModeName => nameValue;

  /// Indicates whether the application should follow the device theme.
  bool get isDefault => this == AppTheme.system;

  /// Converts a persisted string into an [AppTheme].
  ///
  /// If the supplied value is:
  ///
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default theme ([AppTheme.system]) is returned.
  static AppTheme fromValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTheme.system;
    }

    final normalizedValue = value.trim().toLowerCase();

    return AppTheme.values.firstWhere(
      (theme) => theme.nameValue == normalizedValue,
      orElse: () => AppTheme.system,
    );
  }

  /// Returns whether a persisted theme value is supported.
  static bool isSupported(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = value.trim().toLowerCase();

    return AppTheme.values.any((theme) => theme.nameValue == normalizedValue);
  }

  /// List of all supported persisted theme values.
  ///
  /// Useful for:
  /// - validation
  /// - Settings
  /// - SharedPreferences
  /// - analytics
  static const List<String> supportedValues = ['system', 'light', 'dark'];
}
