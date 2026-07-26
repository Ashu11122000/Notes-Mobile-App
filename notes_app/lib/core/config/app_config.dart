import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: app_config.dart
/// ============================================================================
///
/// Centralized application configuration.
///
/// This class contains compile-time application configuration used throughout
/// the project. Configuration values are injected using `--dart-define`,
/// allowing different environments (development, staging, production) without
/// changing source code.
///
/// Example:
///
/// ```bash
/// flutter run \
///   --dart-define=BASE_URL=http://10.0.2.2:8000 \
///   --dart-define=APP_ENV=development
/// ```
///
/// Supported URLs:
///
/// Android Emulator:
///   http://10.0.2.2:8000
///
/// iOS Simulator:
///   http://localhost:8000
///
/// Physical Device:
///   http://<YOUR_LOCAL_IP>:8000
///
/// Production:
///   https://api.yourdomain.com
///
/// This class intentionally contains only compile-time constants and lightweight
/// getters to keep startup time minimal and avoid runtime allocations.
/// ============================================================================
@immutable
final class AppConfig {
  const AppConfig._();

  // ===========================================================================
  // Environment
  // ===========================================================================

  /// Current application environment.
  ///
  /// Examples:
  /// - development
  /// - staging
  /// - production
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  // ===========================================================================
  // API Configuration
  // ===========================================================================

  /// Backend server base URL.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// REST API version.
  ///
  /// Keep this synchronized with the backend.
  static const String apiVersion = '/api/v1';

  /// Complete API base URL.
  ///
  /// Example:
  ///
  /// http://10.0.2.2:8000/api/v1
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  /// Creates a fully-qualified API endpoint.
  ///
  /// Example:
  ///
  /// ```dart
  /// final uri = AppConfig.endpoint('/notes');
  /// ```
  static Uri endpoint(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$apiBaseUrl$normalizedPath');
  }

  // ===========================================================================
  // Network Configuration
  // ===========================================================================

  /// Connection timeout.
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Receive timeout.
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Upload timeout.
  static const Duration sendTimeout = Duration(seconds: 20);

  // ===========================================================================
  // Pagination
  // ===========================================================================

  /// Default first page.
  static const int defaultPage = 1;

  /// Default number of records per page.
  static const int defaultPageSize = 20;

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Debounce duration for search inputs.
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // ===========================================================================
  // Image Upload
  // ===========================================================================

  /// Maximum allowed image size (5 MB).
  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  // ===========================================================================
  // Build Modes
  // ===========================================================================

  /// Whether the application is running in debug mode.
  static bool get isDebug => kDebugMode;

  /// Whether the application is running in profile mode.
  static bool get isProfile => kProfileMode;

  /// Whether the application is running in release mode.
  static bool get isRelease => kReleaseMode;

  // ===========================================================================
  // Validation
  // ===========================================================================

  /// Returns true if the configured base URL appears valid.
  static bool get isValidBaseUrl {
    final uri = Uri.tryParse(baseUrl);

    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  // ===========================================================================
  // Debug Helpers
  // ===========================================================================

  /// Prints the current application configuration.
  ///
  /// This method executes only in debug mode.
  static void printConfiguration() {
    if (!isDebug) return;

    debugPrint('''
================ App Configuration ================
Environment      : $environment
Base URL         : $baseUrl
API Base URL     : $apiBaseUrl
API Version      : $apiVersion
Debug Mode       : $isDebug
Profile Mode     : $isProfile
Release Mode     : $isRelease
Connect Timeout  : ${connectTimeout.inSeconds}s
Receive Timeout  : ${receiveTimeout.inSeconds}s
Send Timeout     : ${sendTimeout.inSeconds}s
Default Page     : $defaultPage
Page Size        : $defaultPageSize
Search Debounce  : ${searchDebounce.inMilliseconds} ms
Image Size Limit : ${maxImageSizeBytes ~/ (1024 * 1024)} MB
===================================================
''');
  }
}
