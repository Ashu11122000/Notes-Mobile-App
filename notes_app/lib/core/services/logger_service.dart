import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// ============================================================================
/// File: logger_service.dart
/// ============================================================================
///
/// Enterprise logging service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Provides a centralized logging API.
/// • Wraps the third-party `logger` package.
/// • Ensures consistent log formatting.
/// • Avoids direct dependency on the logging package throughout the app.
/// • Supports future integration with Crashlytics, Sentry, or remote logging.
///
/// This service intentionally contains no business logic.
///
/// In release builds, verbose logging is automatically disabled to avoid
/// unnecessary overhead.
/// ============================================================================
@immutable
final class LoggerService {
  LoggerService._();

  static Logger? _logger;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  /// Initializes the logger.
  ///
  /// Safe to call multiple times.
  static void initialize() {
    _logger ??= Logger(
      filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  /// Returns the shared logger instance.
  static Logger get instance {
    initialize();
    return _logger!;
  }

  // ===========================================================================
  // Logging
  // ===========================================================================

  /// Trace log.
  static void trace(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.t(message, error: error, stackTrace: stackTrace);
  }

  /// Debug log.
  static void debug(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.d(message, error: error, stackTrace: stackTrace);
  }

  /// Information log.
  static void info(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning log.
  static void warning(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    instance.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error log.
  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal log.
  static void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) {
    instance.f(message, error: error, stackTrace: stackTrace);
  }

  // ===========================================================================
  // Cleanup
  // ===========================================================================

  /// Closes the logger.
  ///
  /// Reserved for future custom outputs such as:
  /// - File logging
  /// - Remote logging
  /// - Crash reporting
  static Future<void> close() async {
    await instance.close();
  }
}
