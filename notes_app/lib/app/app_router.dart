import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';

/// ============================================================================
/// File: app_router.dart
/// ============================================================================
///
/// Centralized application router.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Defines all application routes.
/// - Provides a single navigation entry point.
/// - Handles unknown routes.
/// - Prepares for authentication redirects.
///
/// Authentication redirects will be implemented after the authentication
/// flow is fully completed and tested.
/// ============================================================================
final class AppRouter {
  const AppRouter._();

  /// Root navigator key.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Application router.
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,

    // Authentication redirect will be implemented later.
    // redirect: (context, state) {},
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: AppRoutes.notes,
        builder: (context, state) {
          // Placeholder until the Notes feature is implemented.
          return const Scaffold(body: Center(child: Text('Notes Screen')));
        },
      ),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: const Center(
          child: Text('404\nPage Not Found', textAlign: TextAlign.center),
        ),
      );
    },
  );
}
