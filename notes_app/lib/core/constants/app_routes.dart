import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: app_routes.dart
/// ============================================================================
///
/// Centralized application route definitions.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines all route paths.
/// • Defines all route names.
/// • Prevents hardcoded route strings.
/// • Provides a single source of truth for navigation.
/// • Used by GoRouter throughout the application.
/// • Supports future route expansion.
///
/// This file intentionally contains only compile-time constants and lightweight
/// helper methods to keep routing fast and maintainable.
///
/// Route Naming Convention
/// ----------------------------------------------------------------------------
/// Path:
///   /notes
///   /notes/add
///
/// Name:
///   notes
///   add-note
///
/// Dynamic routes should use helper methods instead of string concatenation.
///
/// Example:
///
/// ```dart
/// context.go(AppRoutes.notes);
///
/// context.push(AppRoutes.addNote);
///
/// context.push(
///   AppRoutes.noteDetailById(12),
/// );
/// ```
/// ============================================================================
@immutable
final class AppRoutes {
  const AppRoutes._();

  // ===========================================================================
  // Root
  // ===========================================================================

  /// Splash screen.
  static const String splash = '/';

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String authRoot = '';

  /// Login screen.
  static const String login = '/login';

  /// Register screen.
  static const String register = '/register';

  // ===========================================================================
  // Notes
  // ===========================================================================

  static const String notesRoot = '/notes';

  /// Notes home.
  static const String notes = notesRoot;

  /// Create note.
  static const String addNote = '$notesRoot/add';

  /// Edit note.
  static const String editNote = '$notesRoot/edit';

  /// Note details.
  static const String noteDetail = '$notesRoot/detail';

  // ===========================================================================
  // Settings
  // ===========================================================================

  static const String settingsRoot = '/settings';

  /// Settings screen.
  static const String settings = settingsRoot;

  /// Notification settings.
  static const String notificationSettings = '$settingsRoot/notifications';

  // ===========================================================================
  // Route Names
  // ===========================================================================

  static const String splashName = 'splash';

  // Authentication

  static const String loginName = 'login';

  static const String registerName = 'register';

  // Notes

  static const String notesName = 'notes';

  static const String addNoteName = 'add-note';

  static const String editNoteName = 'edit-note';

  static const String noteDetailName = 'note-detail';

  // Settings

  static const String settingsName = 'settings';

  static const String notificationSettingsName = 'notification-settings';

  // ===========================================================================
  // Dynamic Route Helpers
  // ===========================================================================

  /// Returns a route for a specific note.
  ///
  /// Example:
  ///
  /// ```dart
  /// context.push(AppRoutes.noteDetailById(25));
  /// ```
  static String noteDetailById(int id) => '$noteDetail/$id';

  /// Returns a route for editing a specific note.
  ///
  /// Example:
  ///
  /// ```dart
  /// context.push(AppRoutes.editNoteById(25));
  /// ```
  static String editNoteById(int id) => '$editNote/$id';

  // ===========================================================================
  // Route Predicates
  // ===========================================================================

  /// Returns whether the given location belongs to the authentication flow.
  static bool isAuthRoute(String location) {
    return location == login || location == register;
  }

  /// Returns whether the given location belongs to the notes module.
  static bool isNotesRoute(String location) {
    return location.startsWith(notesRoot);
  }

  /// Returns whether the given location belongs to the settings module.
  static bool isSettingsRoute(String location) {
    return location.startsWith(settingsRoot);
  }
}
