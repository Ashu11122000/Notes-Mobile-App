import 'package:flutter/widgets.dart';

/// =============================================================================
/// File: app_language.dart
/// =============================================================================
///
/// Defines the application languages supported by the Notes App.
///
/// This enum serves as the single source of truth for language metadata,
/// ensuring type safety and making future localization straightforward.
///
/// New languages can be added by introducing another enum value without
/// modifying lookup logic.
///
/// Example:
/// ```dart
/// final language = AppLanguage.fromCode('hi-IN');
///
/// print(language.displayName); // Hindi
/// print(language.code);        // hi
/// print(language.locale);      // Locale('hi')
/// ```
enum AppLanguage {
  /// English (default application language).
  english(code: 'en', displayName: 'English'),

  /// Hindi.
  hindi(code: 'hi', displayName: 'Hindi');

  /// Creates an application language.
  const AppLanguage({required this.code, required this.displayName});

  /// ISO 639-1 language code.
  final String code;

  /// User-visible language name.
  final String displayName;

  /// Flutter locale.
  Locale get locale => Locale(code);

  /// Whether this is the application's default language.
  bool get isDefault => this == AppLanguage.english;

  /// Returns the language corresponding to the given language code.
  ///
  /// Supports values such as:
  /// - en
  /// - en-US
  /// - en_US
  /// - hi
  /// - hi-IN
  /// - hi_IN
  ///
  /// Falls back to [AppLanguage.english] when the code is null,
  /// empty, or unsupported.
  static AppLanguage fromCode(String? code) {
    final value = code?.trim();

    if (value == null || value.isEmpty) {
      return AppLanguage.english;
    }

    final normalizedCode = value.toLowerCase().split(RegExp(r'[-_]')).first;

    return values.firstWhere(
      (language) => language.code == normalizedCode,
      orElse: () => AppLanguage.english,
    );
  }

  /// Returns whether the given language code is supported.
  static bool isSupported(String? code) {
    final value = code?.trim();

    if (value == null || value.isEmpty) {
      return false;
    }

    final normalizedCode = value.toLowerCase().split(RegExp(r'[-_]')).first;

    return values.any((language) => language.code == normalizedCode);
  }

  /// Returns the display name for a language code.
  static String displayNameOf(String? code) => fromCode(code).displayName;

  /// Supported ISO language codes.
  static List<String> get supportedCodes =>
      values.map((e) => e.code).toList(growable: false);

  /// Supported Flutter locales.
  static List<Locale> get supportedLocales =>
      values.map((e) => e.locale).toList(growable: false);
}
