import 'package:logger/logger.dart';

/// Centralized logging service.
///
/// This class wraps the third-party `logger` package to provide a single,
/// consistent logging API throughout the application.
///
/// Benefits:
/// - Single logging entry point
/// - Easy to mock in tests
/// - Easy to replace logging implementation
/// - Consistent log formatting
final class LoggerService {
  LoggerService._();

  static late Logger _logger;

  /// Initializes the logger.
  ///
  /// Safe to call multiple times.
  static void initialize() {
    _logger = Logger(
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
  static Logger get instance => _logger;

  /// Debug log.
  static void debug(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Information log.
  static void info(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning log.
  static void warning(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error log.
  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal log.
  static void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
