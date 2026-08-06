import '../core/services/logger_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/timezone_service.dart';
import '../core/storage/shared_preferences_service.dart';

/// ============================================================================
/// File: app_initializer.dart
/// ============================================================================
///
/// Application Initializer
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Performs one-time application startup initialization.
/// • Initializes global application services.
/// • Prevents duplicate initialization.
/// • Keeps startup order predictable.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
/// 1. LoggerService
/// 2. SharedPreferencesService
/// 3. TimezoneService
/// 4. NotificationService
///
/// Architecture
/// ----------------------------------------------------------------------------
/// main.dart
///    ↓
/// AppInitializer
///    ↓
/// Global Services
///
/// ============================================================================

// AppInitializer is a class that performs one-time application startup initialization.
final class AppInitializer {

  // Private constructor to prevent instantiation of the class. 
  // instantiation is not needed because all methods and properties of the class are static.
  // instance of a class means that the class is a singleton (only one instance of the class can exist at a time).
  const AppInitializer._();

  // Here, we are declaring a static property called _initialized that is a boolean value.
  static bool _initialized = false;

  // Here, _initializationFuture is a static property that is a Future that represents the asynchronous operation that is being performed.
  // Future<void>? is a type that represents a value that may or may not be present.
  static Future<void>? _initializationFuture;

  /// Whether application initialization completed.
  static bool get isInitialized => _initialized;

  // Here, we are defining a static method called initialize that returns a Future<void> object.
  static Future<void> initialize() {
    return _initializationFuture ??= _initialize();
  }

  // Here, Future<void> _initialize() async is a method that is used to perform the asynchronous operation that is being performed.
  static Future<void> _initialize() async {

    // Here, we are declaring a variable called stopwatch that is an instance of the Stopwatch class.
    // Stopwatch is a class that is used to measure the elapsed time of an operation.
    // elapsed time is the amount of time that has passed since the operation started.
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      if (_initialized) {
        LoggerService.info('Application already initialized.');

        return;
      }

      // =========================================================================
      // Logger
      // =========================================================================
      //
      // LoggerService is static in this project.
      // No initialization required.
      //

      LoggerService.info('Application initialization started.');

      // =========================================================================
      // Shared Preferences
      // =========================================================================

      // SharedPreferencesService is a class that is used to store key-value pairs in the device's local storage.
      await SharedPreferencesService.initialize();

      LoggerService.info('SharedPreferences initialized.');

      // =========================================================================
      // Timezone
      // =========================================================================

      await TimezoneService.instance.initialize();

      LoggerService.info('Timezone service initialized.');

      // =========================================================================
      // Notifications
      // =========================================================================

      await NotificationService.instance.initialize();

      LoggerService.info('Notification service initialized.');

      // =========================================================================
      // Completed
      // =========================================================================

      _initialized = true;

      // Allow retry after failed startup.
      stopwatch.stop();

      LoggerService.info(
        'Application initialization completed '
        '(${stopwatch.elapsedMilliseconds}ms).',
      );
    } catch (exception, stackTrace) {
      stopwatch.stop();

      LoggerService.error(
        'Application initialization failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      // Allow retry after failed startup.
      _initializationFuture = null;

      rethrow;
    }
  }

  // ===========================================================================
  // Reset
  // ===========================================================================
  //
  // Only intended for testing.
  // Do not use during normal runtime.
  //

  static void reset() {
    _initialized = false;

    _initializationFuture = null;

    LoggerService.info('Application initializer reset.');
  }
}
