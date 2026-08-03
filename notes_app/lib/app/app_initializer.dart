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

final class AppInitializer {
  const AppInitializer._();

  static bool _initialized = false;

  static Future<void>? _initializationFuture;

  /// Whether application initialization completed.
  static bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialize Application
  // ===========================================================================

  static Future<void> initialize() {
    return _initializationFuture ??= _initialize();
  }

  static Future<void> _initialize() async {
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
