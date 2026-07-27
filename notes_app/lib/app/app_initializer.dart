import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
/// • Initializes global services.
/// • Keeps initialization order consistent.
/// • Prevents duplicate initialization.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
/// 1. Logger
/// 2. SharedPreferences
/// 3. Timezone
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

  /// Whether application initialization completed.
  static bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialize Application
  // ===========================================================================

  static Future<void> initialize({
    void Function(NotificationResponse response)? onNotificationTap,
  }) async {
    if (_initialized) {
      LoggerService.info('Application already initialized.');

      return;
    }

    try {
      // =======================================================================
      // Logger
      // =======================================================================

      LoggerService.initialize();

      LoggerService.info('Application initialization started.');

      // =======================================================================
      // Shared Preferences
      // =======================================================================

      await SharedPreferencesService.initialize();

      LoggerService.info('SharedPreferences initialized.');

      // =======================================================================
      // Timezone
      // =======================================================================

      await TimezoneService.instance.initialize();

      LoggerService.info('Timezone service initialized.');

      // =======================================================================
      // Notifications
      // =======================================================================

      await NotificationService.instance.initialize(
        onNotificationTap: onNotificationTap,
      );

      LoggerService.info('Notification service initialized.');

      // =======================================================================
      // Completed
      // =======================================================================

      _initialized = true;

      LoggerService.info('Application initialization completed successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Application initialization failed.',

        error: exception,

        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Reset
  // ===========================================================================

  static void reset() {
    _initialized = false;

    LoggerService.info('Application initializer reset.');
  }
}
