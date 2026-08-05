import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'logger_service.dart';

/// ============================================================================
/// File: timezone_service.dart
/// ============================================================================
///
/// Enterprise Timezone Service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Initializes the timezone database.
/// • Detects the device timezone.
/// • Normalizes legacy timezone names.
/// • Sets the application's local timezone.
/// • Provides TZDateTime helpers.
///
/// This service must be initialized once during application startup.
///
/// Compatible with:
/// • flutter_timezone ^5.1.0
/// • timezone ^0.11.x
///
/// ============================================================================
final class TimezoneService {
  TimezoneService._();

  static final TimezoneService instance = TimezoneService._();

  static const Map<String, String> _legacyTimezones = {
    'Asia/Calcutta': 'Asia/Kolkata',
    'US/Eastern': 'America/New_York',
    'US/Central': 'America/Chicago',
    'US/Mountain': 'America/Denver',
    'US/Pacific': 'America/Los_Angeles',
  };

  bool _initialized = false;

  bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Load timezone database.
      tz.initializeTimeZones();

      final dynamic rawTimezone = await FlutterTimezone.getLocalTimezone();
      final String timezoneName = rawTimezone is String
          ? rawTimezone
          : (rawTimezone.timezone as String? ?? 'UTC');

      final String timezone =
          _legacyTimezones[timezoneName] ?? timezoneName;

      try {
        final tz.Location location = tz.getLocation(timezone);

        tz.setLocalLocation(location);

        LoggerService.info('Timezone initialized: ${location.name}');
      } catch (_) {
        LoggerService.warning(
          'Unknown timezone "$timezone". Falling back to UTC.',
        );

        tz.setLocalLocation(tz.UTC);
      }

      _initialized = true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Timezone initialization failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      tz.setLocalLocation(tz.UTC);

      _initialized = true;
    }
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  void _ensureInitialized() {
    if (_initialized) {
      return;
    }

    throw StateError(
      'TimezoneService has not been initialized. '
      'Call initialize() before using timezone helpers.',
    );
  }

  tz.Location get localLocation {
    _ensureInitialized();
    return tz.local;
  }

  tz.TZDateTime now() {
    _ensureInitialized();
    return tz.TZDateTime.now(tz.local);
  }

  tz.TZDateTime toTZDateTime(DateTime dateTime) {
    _ensureInitialized();
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  tz.TZDateTime? toNullableTZDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    return toTZDateTime(dateTime);
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    _initialized = false;
  }
}
