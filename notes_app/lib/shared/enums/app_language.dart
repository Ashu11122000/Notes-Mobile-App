/// Represents the supported application languages.
///
/// This enum is intended for future localization support and will be
/// consumed by the Settings feature.
///
/// Example:
/// ```dart
/// AppLanguage.english.code;      // en
/// AppLanguage.hindi.displayName; // Hindi
/// ```
enum AppLanguage {
  /// English language.
  english(code: 'en', displayName: 'English'),

  /// Hindi language.
  hindi(code: 'hi', displayName: 'Hindi');

  /// Creates an application language.
  const AppLanguage({required this.code, required this.displayName});

  /// ISO language code.
  final String code;

  /// User-friendly language name.
  final String displayName;

  /// Returns the enum from an ISO language code.
  ///
  /// Defaults to [AppLanguage.english] if no match is found.
  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
