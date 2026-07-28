import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: app_routes.dart
/// =============================================================================
///
/// Centralized application route definitions.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Defines all route paths.
/// • Defines all GoRouter route names.
/// • Prevents hardcoded route strings.
/// • Provides route helper methods.
/// • Supports dynamic routes.
/// • Provides route classification helpers.
///
/// =============================================================================

@immutable
final class AppRoutes {
  const AppRoutes._();

  // ===========================================================================
  // Initial
  // ===========================================================================

  static const String splash = '/';

  static const String splashName = 'splash';

  static const String initialRoute = splash;

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String login = '/login';

  static const String loginName = 'login';

  static const String register = '/register';

  static const String registerName = 'register';

  // ===========================================================================
  // Notes
  // ===========================================================================

  static const String notesRoot = '/notes';

  static const String notes = notesRoot;

  static const String notesName = 'notes';

  static const String addNote = '$notesRoot/add';

  static const String addNoteName = 'add-note';

  static const String editNote = '$notesRoot/edit';

  static const String editNoteName = 'edit-note';

  static const String noteDetail = '$notesRoot/detail';

  static const String noteDetailName = 'note-detail';

  /// GoRouter parameter name.
  static const String noteIdParam = 'id';

  // ===========================================================================
  // Profile
  // ===========================================================================

  static const String profileRoot = '/profile';

  static const String profile = profileRoot;

  static const String profileName = 'profile';

  static const String editProfile = '$profileRoot/edit';

  static const String editProfileName = 'edit-profile';

  // ===========================================================================
  // Settings
  // ===========================================================================

  static const String settingsRoot = '/settings';

  static const String settings = settingsRoot;

  static const String settingsName = 'settings';

  static const String notificationSettings = '$settingsRoot/notifications';

  static const String notificationSettingsName = 'notification-settings';

  // ===========================================================================
  // Public Routes
  // ===========================================================================

  static const Set<String> publicRoutes = <String>{splash, login, register};

  // ===========================================================================
  // Dynamic Helpers
  // ===========================================================================

  static String noteDetailById(Object id) =>
      '$noteDetail/${Uri.encodeComponent(id.toString())}';

  static String editNoteById(Object id) =>
      '$editNote/${Uri.encodeComponent(id.toString())}';

  // ===========================================================================
  // Route Helpers
  // ===========================================================================

  static bool isPublicRoute(String location) => publicRoutes.contains(location);

  static bool isProtectedRoute(String location) => !isPublicRoute(location);

  static bool isAuthRoute(String location) =>
      location == login || location == register;

  static bool isNotesRoute(String location) => location.startsWith(notesRoot);

  static bool isProfileRoute(String location) =>
      location.startsWith(profileRoot);

  static bool isSettingsRoute(String location) =>
      location.startsWith(settingsRoot);
}
