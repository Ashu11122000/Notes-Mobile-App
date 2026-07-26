import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: storage_constants.dart
/// ============================================================================
///
/// Centralized local storage keys.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines all persistent storage keys.
/// • Prevents hardcoded string literals.
/// • Improves maintainability.
/// • Provides a single source of truth for SharedPreferences,
///   secure storage, and future local persistence solutions.
///
/// This class contains only compile-time constants and therefore has
/// zero runtime overhead.
///
/// Naming convention:
///
/// feature_name_setting
///
/// Example:
///
/// auth_access_token
/// auth_refresh_token
/// app_theme_mode
/// notes_sort_by
///
/// Using feature prefixes minimizes the chance of key collisions as the
/// application grows.
/// ============================================================================
@immutable
final class StorageConstants {
  const StorageConstants._();

  // ===========================================================================
  // Authentication
  // ===========================================================================

  /// JWT access token.
  static const String accessToken = 'auth_access_token';

  /// JWT refresh token.
  ///
  /// Reserved for future backend support.
  static const String refreshToken = 'auth_refresh_token';

  /// Logged-in status.
  static const String isLoggedIn = 'auth_is_logged_in';

  // ===========================================================================
  // User
  // ===========================================================================

  /// Cached authenticated user.
  static const String currentUser = 'user_current';

  /// Last logged-in email.
  static const String lastEmail = 'user_last_email';

  // ===========================================================================
  // Application
  // ===========================================================================

  /// First application launch.
  static const String isFirstLaunch = 'app_first_launch';

  /// Current application version.
  static const String appVersion = 'app_version';

  /// Last successful synchronization.
  static const String lastSync = 'app_last_sync';

  // ===========================================================================
  // Theme
  // ===========================================================================

  /// Selected theme mode.
  static const String themeMode = 'app_theme_mode';

  /// Dynamic color preference.
  static const String dynamicColor = 'app_dynamic_color';

  // ===========================================================================
  // Localization
  // ===========================================================================

  /// Selected application language.
  static const String language = 'app_language';

  // ===========================================================================
  // Notes
  // ===========================================================================

  /// Last selected sort option.
  static const String noteSortBy = 'notes_sort_by';

  /// Last selected filter.
  static const String noteFilter = 'notes_filter';

  /// Last opened note.
  static const String lastOpenedNoteId = 'notes_last_opened';

  /// Cached search query.
  static const String searchQuery = 'notes_search_query';

  // ===========================================================================
  // Notifications
  // ===========================================================================

  /// Whether notifications are enabled.
  static const String notificationsEnabled = 'notifications_enabled';

  // ===========================================================================
  // Image Picker
  // ===========================================================================

  /// Last selected image source.
  static const String imageSource = 'image_source';

  // ===========================================================================
  // Developer
  // ===========================================================================

  /// Enables verbose logging.
  static const String debugLogging = 'developer_debug_logging';
}
