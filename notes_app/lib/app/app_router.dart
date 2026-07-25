import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';

import '../features/notes/domain/entities/note.dart';
import '../features/notes/presentation/screens/add_note_screen.dart';
import '../features/notes/presentation/screens/edit_note_screen.dart';
import '../features/notes/presentation/screens/note_detail_screen.dart';
import '../features/notes/presentation/screens/notes_screen.dart';

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
/// - Supports strongly typed navigation.
/// - Handles invalid navigation gracefully.
/// - Handles unknown routes.
/// - Prepares for authentication redirects.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// App
///     ↓
/// GoRouter
///     ↓
/// Authentication Routes
/// Notes Routes
///
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
    //
    // redirect: (context, state) {
    //   ...
    // },
    routes: <RouteBase>[
      // =======================================================================
      // Authentication
      // =======================================================================
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // =======================================================================
      // Notes
      // =======================================================================
      GoRoute(
        path: AppRoutes.notes,
        builder: (context, state) => const NotesScreen(),
      ),

      GoRoute(
        path: AppRoutes.addNote,
        builder: (context, state) => const AddNoteScreen(),
      ),

      GoRoute(
        path: AppRoutes.editNote,
        builder: (context, state) {
          final Object? extra = state.extra;

          if (extra is! Note) {
            return const _InvalidNavigationScreen(
              message: 'Invalid note supplied for editing.',
            );
          }

          return EditNoteScreen(note: extra);
        },
      ),

      GoRoute(
        path: AppRoutes.noteDetail,
        builder: (context, state) {
          final Object? extra = state.extra;

          if (extra is! Note) {
            return const _InvalidNavigationScreen(
              message: 'Invalid note supplied for viewing.',
            );
          }

          return NoteDetailScreen(note: extra);
        },
      ),
    ],

    // =======================================================================
    // Unknown Route
    // =======================================================================
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              '404\n\nThe requested page could not be found.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}

/// ============================================================================
/// Invalid Navigation Screen
/// ============================================================================
///
/// Displayed when a required route argument is missing or invalid.
///
/// ============================================================================

final class _InvalidNavigationScreen extends StatelessWidget {
  const _InvalidNavigationScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
