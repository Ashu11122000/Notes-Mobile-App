/// Centralized application route names.
///
/// All application routes used by GoRouter should be defined here.
/// This avoids hardcoded route strings throughout the application.
final class AppRoutes {
  const AppRoutes._();

  // ===========================================================================
  // Authentication
  // ===========================================================================

  /// Splash screen.
  static const String splash = '/';

  /// Login screen.
  static const String login = '/login';

  /// Register screen.
  static const String register = '/register';

  // ===========================================================================
  // Notes
  // ===========================================================================

  /// Notes home screen.
  static const String notes = '/notes';
}
