import '../core/services/logger_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/timezone_service.dart';
import '../core/storage/shared_preferences_service.dart';

/// ============================================================================
/// File: app_initializer.dart
/// ============================================================================
///
/// Performs one-time application initialization before the UI is launched.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Initialize Logger
/// - Initialize SharedPreferences
/// - Initialize Timezone
/// - Initialize Local Notifications
/// - Initialize future application-wide services
///
/// Keep this class lightweight by delegating initialization logic to the
/// respective service classes.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
/// 1. Logger
/// 2. SharedPreferences
/// 3. Timezone
/// 4. NotificationService
///
/// ============================================================================

final class AppInitializer {
  const AppInitializer._();

  /// Initializes all application dependencies.
  static Future<void> initialize() async {
    try {
      // -----------------------------------------------------------------------
      // Logger
      // -----------------------------------------------------------------------

      LoggerService.initialize();

      LoggerService.info('Application initialization started.');

      // -----------------------------------------------------------------------
      // Shared Preferences
      // -----------------------------------------------------------------------

      await SharedPreferencesService.initialize();

      LoggerService.info('SharedPreferences initialized.');

      // -----------------------------------------------------------------------
      // Timezone
      // -----------------------------------------------------------------------

      await TimezoneService.instance.initialize();

      LoggerService.info('TimezoneService initialized.');

      // -----------------------------------------------------------------------
      // Local Notifications
      // -----------------------------------------------------------------------

      await NotificationService.instance.initialize();

      LoggerService.info('NotificationService initialized.');

      // -----------------------------------------------------------------------
      // Future global services
      // -----------------------------------------------------------------------

      LoggerService.info('Application initialization completed.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Application initialization failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
