import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: app_config.dart
/// ============================================================================
///
/// Application runtime configuration.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Stores environment configuration.
/// • Stores backend base URL.
/// • Stores network settings.
/// • Supports dart-define environments.
///
/// API paths are NOT stored here.
/// Use ApiConstants for endpoints.
///
/// ============================================================================

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

  // ===========================================================================
  // Backend Configuration
  // ===========================================================================

  /// Backend root URL.
  ///
  /// Android Emulator:
  /// http://10.0.2.2:8000
  ///
  /// Physical Device:
  /// http://YOUR_LOCAL_IP:8000
  ///
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// API version prefix.
  ///
  /// Used only by ApiConstants.
  static const String apiVersion = '/api/v1';

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

  // ===========================================================================
  // Search
  // ===========================================================================

  static const Duration searchDebounce = Duration(milliseconds: 400);

  // ===========================================================================
  // Upload
  // ===========================================================================

  static const int maxImageSizeBytes = 5 * 1024 * 1024;

  // ===========================================================================
  // Build Mode
  // ===========================================================================

  static bool get isDebug => kDebugMode;

  static bool get isProfile => kProfileMode;

  static bool get isRelease => kReleaseMode;

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

Environment      : $environment

Base URL         : $baseUrl

API Version      : $apiVersion

Debug            : $isDebug

Profile          : $isProfile

Release          : $isRelease

Connect Timeout  : ${connectTimeout.inSeconds}s

Receive Timeout  : ${receiveTimeout.inSeconds}s

Send Timeout     : ${sendTimeout.inSeconds}s

===================================================
''');
  }
}
