/// ============================================================================
/// File: app_routes.dart
/// ============================================================================
///
/// Centralized application route constants.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Defines all application route paths.
/// - Defines all application route names.
/// - Prevents hardcoded route strings.
/// - Provides a single source of truth for navigation.
/// - Used by GoRouter throughout the application.
///
/// ============================================================================

final class AppRoutes {
  const AppRoutes._();

  // ===========================================================================
  // Authentication - Paths
  // ===========================================================================

  /// Splash screen.
  static const String splash = '/';

  /// Login screen.
  static const String login = '/login';

  /// Register screen.
  static const String register = '/register';

  // ===========================================================================
  // Notes - Paths
  // ===========================================================================

  /// Notes home screen.
  static const String notes = '/notes';

  /// Add Note screen.
  static const String addNote = '/notes/add';

  /// Edit Note screen.
  static const String editNote = '/notes/edit';

  /// Note Details screen.
  static const String noteDetail = '/notes/detail';

  // ===========================================================================
  // Route Names
  // ===========================================================================

  static const String splashName = 'splash';

  static const String loginName = 'login';

  static const String registerName = 'register';

  static const String notesName = 'notes';

  static const String addNoteName = 'add-note';

  static const String editNoteName = 'edit-note';

  static const String noteDetailName = 'note-detail';
}
