/// =============================================================================
/// File: app_language.dart
/// =============================================================================
///
/// Defines the application languages supported by the Notes App.
///
/// This enum acts as the single source of truth for language metadata,
/// making it easy to integrate Flutter localization (`gen_l10n` or
/// `flutter_localizations`) in the future.
///
/// Keeping language information centralized avoids scattered string literals
/// throughout the codebase and provides strong type safety.
///
/// Current supported languages:
/// - English
/// - Hindi
///
/// Example:
/// ```dart
/// final language = AppLanguage.fromCode('hi');
///
/// print(language.displayName); // Hindi
/// print(language.code);        // hi
/// print(language.localeTag);   // hi
/// ```
enum AppLanguage {
  /// English (default application language).
  english(code: 'en', displayName: 'English'),

  /// Hindi.
  hindi(code: 'hi', displayName: 'Hindi');

  /// Creates an application language.
  const AppLanguage({required this.code, required this.displayName});

  /// ISO 639-1 language code.
  ///
  /// Examples:
  /// - `en`
  /// - `hi`
  final String code;

  /// User-visible language name.
  final String displayName;

  /// Locale identifier used when constructing a Flutter [Locale].
  ///
  /// Example:
  /// ```dart
  /// Locale(AppLanguage.english.localeTag);
  /// ```
  String get localeTag => code;

  /// Indicates whether this is the application's default language.
  bool get isDefault => this == AppLanguage.english;

  /// Returns the corresponding [AppLanguage] for the given ISO language code.
  ///
  /// If the provided value is:
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default language ([AppLanguage.english]) is returned.
  static AppLanguage fromCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return AppLanguage.english;
    }

    final normalizedCode = code.trim().toLowerCase();

    return AppLanguage.values.firstWhere(
      (language) => language.code == normalizedCode,
      orElse: () => AppLanguage.english,
    );
  }

  /// Returns whether the given language code is supported.
  static bool isSupported(String? code) {
    if (code == null || code.trim().isEmpty) {
      return false;
    }

    final normalizedCode = code.trim().toLowerCase();

    return AppLanguage.values.any(
      (language) => language.code == normalizedCode,
    );
  }

  /// List of all supported ISO language codes.
  ///
  /// Useful for:
  /// - API validation
  /// - Settings
  /// - Localization
  /// - Analytics
  static const List<String> supportedCodes = ['en', 'hi'];
}
