import '../core/services/logger_service.dart';
import '../core/services/notification_service.dart';
import '../core/storage/shared_preferences_service.dart';

/// Performs one-time application initialization before the UI is launched.
///
/// This class is responsible for initializing all global services required by
/// the application before the widget tree is built.
///
/// Responsibilities:
/// - Initialize Logger
/// - Initialize SharedPreferences
/// - Initialize Local Notifications
/// - Initialize future application-wide services
///
/// Keep this class lightweight by delegating initialization logic
/// to the respective service classes.
final class AppInitializer {
  const AppInitializer._();

  /// Initializes all application dependencies.
  static Future<void> initialize() async {
    // -------------------------------------------------------------------------
    // Logger
    // -------------------------------------------------------------------------
    LoggerService.initialize();

    // -------------------------------------------------------------------------
    // Shared Preferences
    // -------------------------------------------------------------------------
    await SharedPreferencesService.initialize();

    // -------------------------------------------------------------------------
    // Local Notifications
    // -------------------------------------------------------------------------
    await NotificationService.instance.initialize();

    // -------------------------------------------------------------------------
    // Additional global initialization can be added here.
    // -------------------------------------------------------------------------
  }
}
