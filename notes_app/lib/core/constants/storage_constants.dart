import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: storage_constants.dart
/// =============================================================================
///
/// Centralized storage keys.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Defines all storage keys.
/// • Prevents magic strings.
/// • Supports SharedPreferences, Secure Storage and Hive.
/// • Provides a single source of truth.
///
/// =============================================================================

@immutable
final class StorageConstants {
  const StorageConstants._();

  // ===========================================================================
  // Secure Storage
  // ===========================================================================

  static const String accessToken = 'auth_access_token';

  static const String refreshToken = 'auth_refresh_token';

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String isLoggedIn = 'auth_is_logged_in';

  static const String lastLogin = 'auth_last_login';

  static const String lastTokenRefresh = 'auth_last_token_refresh';

  // ===========================================================================
  // User
  // ===========================================================================

  static const String currentUser = 'user_current';

  static const String lastEmail = 'user_last_email';

  // ===========================================================================
  // Application
  // ===========================================================================

  static const String storageVersion = 'app_storage_version';

  static const String onboardingCompleted = 'app_onboarding_completed';

  static const String appVersion = 'app_version';

  static const String lastSyncTimestamp = 'app_last_sync_timestamp';

  // ===========================================================================
  // Theme
  // ===========================================================================

  static const String themeMode = 'app_theme_mode';

  static const String dynamicColor = 'app_dynamic_color';

  // ===========================================================================
  // Localization
  // ===========================================================================

  static const String language = 'app_language';

  // ===========================================================================
  // Notes
  // ===========================================================================

  static const String noteSortBy = 'notes_sort_by';

  static const String noteFilter = 'notes_filter';

  static const String lastOpenedNoteId = 'notes_last_opened';

  static const String searchQuery = 'notes_search_query';

  // ===========================================================================
  // Notifications
  // ===========================================================================

  static const String notificationsEnabled = 'notifications_enabled';

  static const String notificationPermissionRequested =
      'notifications_permission_requested';

  // ===========================================================================
  // Image Picker
  // ===========================================================================

  static const String imageSource = 'image_source';

  // ===========================================================================
  // Hive Boxes
  // ===========================================================================

  static const String notesBox = 'notes_box';

  static const String settingsBox = 'settings_box';

  static const String cacheBox = 'cache_box';

  // ===========================================================================
  // Developer
  // ===========================================================================

  static const String debugLogging = 'developer_debug_logging';
}
