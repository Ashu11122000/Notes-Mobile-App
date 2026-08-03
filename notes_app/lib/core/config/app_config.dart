import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: app_config.dart
/// =============================================================================
///
/// Application runtime configuration.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Stores compile-time application configuration.
/// • Reads values from --dart-define.
/// • Defines network configuration.
/// • Defines pagination defaults.
/// • Defines upload constraints.
/// • Exposes build mode helpers.
///
/// API endpoints are intentionally NOT stored here.
/// Use ApiConstants for REST paths.
///
/// Example:
///
/// flutter run \
///   --dart-define=APP_ENV=development \
///   --dart-define=BASE_URL=http://10.0.2.2:8000
///
/// =============================================================================

@immutable
final class AppConfig {
  const AppConfig._();

  // ===========================================================================
  // Environment
  // ===========================================================================

  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String apiVersion = '/api/v1';

  /// Fully qualified API base URL.
  ///
  /// Example:
  /// http://10.0.2.2:8000/api/v1
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // ===========================================================================
  // Network
  // ===========================================================================

  static const Duration connectTimeout = Duration(seconds: 15);

  static const Duration receiveTimeout = Duration(seconds: 20);

  static const Duration sendTimeout = Duration(seconds: 20);

  // ===========================================================================
  // Pagination
  // ===========================================================================

  static const int defaultPage = 1;

  static const int defaultPageSize = 20;

  static const int maxPageSize = 100;

  // ===========================================================================
  // Search
  // ===========================================================================

  static const Duration searchDebounce = Duration(milliseconds: 400);

  // ===========================================================================
  // Upload
  // ===========================================================================

  /// 5 MB
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  static const List<String> allowedImageExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // ===========================================================================
  // Build Mode
  // ===========================================================================

  static bool get isDebug => kDebugMode;

  static bool get isProfile => kProfileMode;

  static bool get isRelease => kReleaseMode;

  // ===========================================================================
  // Environment Helpers
  // ===========================================================================

  static bool get isDevelopment => environment.toLowerCase() == 'development';

  static bool get isStaging => environment.toLowerCase() == 'staging';

  static bool get isProduction => environment.toLowerCase() == 'production';

  // ===========================================================================
  // Validation
  // ===========================================================================

  static bool get isValidBaseUrl {
    final Uri? uri = Uri.tryParse(baseUrl);

    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  static void printConfiguration() {
    if (!isDebug) {
      return;
    }

    debugPrint('''
================ App Configuration ================

Environment       : $environment

Base URL          : $baseUrl

API Base URL      : $apiBaseUrl

API Version       : $apiVersion

Debug             : $isDebug

Profile           : $isProfile

Release           : $isRelease

Connect Timeout   : ${connectTimeout.inSeconds}s

Receive Timeout   : ${receiveTimeout.inSeconds}s

Send Timeout      : ${sendTimeout.inSeconds}s

Page Size         : $defaultPageSize

Max Page Size     : $maxPageSize

Image Limit       : ${maxImageSizeBytes ~/ (1024 * 1024)} MB

===================================================
''');
  }
}
