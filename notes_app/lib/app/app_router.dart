import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';

/// Centralized application router.
///
/// Responsibilities:
/// - Define application routes
/// - Configure global navigation
/// - Handle unknown routes
/// - Prepare for authentication redirects
///
/// Authentication redirects will be added after the
/// authentication module is implemented.
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

    // Authentication redirects will be added later.
    // redirect: (context, state) {},
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SizedBox.shrink(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const SizedBox.shrink(),
      ),
      GoRoute(
        path: AppRoutes.notes,
        builder: (_, __) => const SizedBox.shrink(),
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
