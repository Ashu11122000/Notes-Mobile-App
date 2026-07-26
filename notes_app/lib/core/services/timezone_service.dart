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
/// • Initializes the timezone database.
/// • Detects the device timezone.
/// • Normalizes legacy timezone names.
/// • Sets the application's local timezone.
/// • Provides helper methods for scheduled notifications.
///
/// This service must be initialized once during application startup.
///
/// ============================================================================

final class TimezoneService {
  TimezoneService._();

  static final TimezoneService instance = TimezoneService._();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Load the complete timezone database.
      tz.initializeTimeZones();

      String timezoneName = await FlutterTimezone.getLocalTimezone();

      // -----------------------------------------------------------------------
      // Normalize legacy timezone names returned by some Android devices.
      // -----------------------------------------------------------------------

      timezoneName = _normalizeTimezone(timezoneName);

      tz.Location location;

      try {
        location = tz.getLocation(timezoneName);
      } catch (_) {
        LoggerService.warning(
          'Unknown timezone "$timezoneName". Falling back to UTC.',
        );

        location = tz.UTC;
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

      // Never allow timezone initialization to crash the application.
      tz.setLocalLocation(tz.UTC);

      _initialized = true;
    }
  }

  // ===========================================================================
  // Normalize Timezone
  // ===========================================================================

  String _normalizeTimezone(String timezone) {
    switch (timezone) {
      case 'Asia/Calcutta':
        return 'Asia/Kolkata';

      case 'US/Eastern':
        return 'America/New_York';

      case 'US/Central':
        return 'America/Chicago';

      case 'US/Mountain':
        return 'America/Denver';

      case 'US/Pacific':
        return 'America/Los_Angeles';

      default:
        return timezone;
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
