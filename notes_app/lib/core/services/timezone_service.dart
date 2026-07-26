import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'logger_service.dart';

/// ============================================================================
/// File: timezone_service.dart
/// ============================================================================
///
/// Timezone Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Initialize the timezone database.
/// • Detect the device's local timezone.
/// • Configure the application's local timezone.
/// • Provide helper methods used by NotificationService.
///
/// This service must be initialized exactly once during app startup.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// AppInitializer
///        ↓
/// TimezoneService
///        ↓
/// timezone package
///
/// ============================================================================

final class TimezoneService {
  TimezoneService._();

  static final TimezoneService instance = TimezoneService._();

  bool _initialized = false;

  /// Whether the timezone service has been initialized.
  bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Load the timezone database.
      tz.initializeTimeZones();

      // Get the device timezone.
      final String timezoneName = await FlutterTimezone.getLocalTimezone();

      tz.Location location;

      try {
        location = tz.getLocation(timezoneName);
      } catch (_) {
        LoggerService.warning(
          'Unknown timezone "$timezoneName". Falling back to UTC.',
        );

        location = tz.getLocation('UTC');
      }

      tz.setLocalLocation(location);

      _initialized = true;

      LoggerService.info('Timezone initialized successfully: ${location.name}');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize timezone.',
        error: exception,
        stackTrace: stackTrace,
      );

      // Safe fallback.
      tz.setLocalLocation(tz.getLocation('UTC'));

      _initialized = true;
    }
  }

  // ===========================================================================
  // Local Timezone
  // ===========================================================================

  tz.Location get localLocation => tz.local;

  // ===========================================================================
  // Current Time
  // ===========================================================================

  tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  // ===========================================================================
  // Convert DateTime
  // ===========================================================================

  tz.TZDateTime toTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  // ===========================================================================
  // Nullable Conversion
  // ===========================================================================

  tz.TZDateTime? toNullableTZDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    return tz.TZDateTime.from(dateTime, tz.local);
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    _initialized = false;
  }
}
