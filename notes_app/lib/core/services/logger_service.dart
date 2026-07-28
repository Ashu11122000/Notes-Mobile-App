import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config/app_config.dart';

/// =============================================================================
/// File: logger_service.dart
/// =============================================================================
///
/// Enterprise logging service.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Provides a centralized logging API.
/// • Wraps the `logger` package.
/// • Ensures consistent logging across the application.
/// • Prevents direct dependency on third-party logging.
/// • Ready for future Crashlytics/Sentry integration.
///
/// Logging Strategy
/// -----------------------------------------------------------------------------
/// • Debug/Profile:
///     Pretty formatted logs.
///
/// • Release:
///     Production filter with minimal overhead.
///
/// =============================================================================
@immutable
final class LoggerService {
  LoggerService._();

  static final Logger _logger = Logger(
    filter: AppConfig.isRelease ? ProductionFilter() : DevelopmentFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Shared logger instance.
  static Logger get instance => _logger;

  // ===========================================================================
  // Trace
  // ===========================================================================

  static void trace(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  static void debug(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Information
  // ===========================================================================

  static void info(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Warning
  // ===========================================================================

  static void warning(
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Error
  // ===========================================================================

  static void error(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Fatal
  // ===========================================================================

  static void fatal(Object? message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Cleanup
  // ===========================================================================

  /// Reserved for future custom outputs such as:
  ///
  /// • File logging
  /// • Remote logging
  /// • Crashlytics
  /// • Sentry
  static Future<void> close() {
    return _logger.close();
  }
}
