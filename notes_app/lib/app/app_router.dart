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

import '../features/settings/presentation/screens/settings_screen.dart';

import '../features/notifications/presentation/screens/notification_settings_screen.dart';

/// ============================================================================
/// File: app_router.dart
/// ============================================================================
///
/// Application Router
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Centralized route management.
/// • Handles navigation.
/// • Validates route arguments.
/// • Handles unknown routes.
/// • Ready for authentication guards.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
/// UI
/// ↓
/// GoRouter
/// ↓
/// Screens
///
/// ============================================================================

final class AppRouter {
  const AppRouter._();

  // ===========================================================================
  // Navigator Key
  // ===========================================================================

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // ===========================================================================
  // Router Configuration
  // ===========================================================================

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,

    initialLocation: AppRoutes.splash,

    debugLogDiagnostics: kDebugMode,

    routes: <RouteBase>[
      // =======================================================================
      // AUTHENTICATION
      // =======================================================================
      GoRoute(
        name: 'splash',

        path: AppRoutes.splash,

        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        name: 'login',

        path: AppRoutes.login,

        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        name: 'register',

        path: AppRoutes.register,

        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      // =======================================================================
      // NOTES
      // =======================================================================
      GoRoute(
        name: 'notes',

        path: AppRoutes.notes,

        builder: (context, state) {
          return const NotesScreen();
        },
      ),

      GoRoute(
        name: 'add-note',

        path: AppRoutes.addNote,

        builder: (context, state) {
          return const AddNoteScreen();
        },
      ),

      GoRoute(
        name: 'edit-note',

        path: AppRoutes.editNote,

        builder: (context, state) {
          final Object? extra = state.extra;

          if (extra is! Note) {
            return const _InvalidNavigationScreen(
              message: 'Unable to edit note.\nInvalid note data.',
            );
          }

          return EditNoteScreen(note: extra);
        },
      ),

      GoRoute(
        name: 'note-detail',

        path: AppRoutes.noteDetail,

        builder: (context, state) {
          final Object? extra = state.extra;

          if (extra is! Note) {
            return const _InvalidNavigationScreen(
              message: 'Unable to open note details.\nInvalid note data.',
            );
          }

          return NoteDetailScreen(note: extra);
        },
      ),

      // =======================================================================
      // SETTINGS
      // =======================================================================
      GoRoute(
        name: 'settings',

        path: AppRoutes.settings,

        builder: (context, state) {
          return const SettingsScreen();
        },
      ),

      GoRoute(
        name: 'notification-settings',

        path: AppRoutes.notificationSettings,

        builder: (context, state) {
          return const NotificationSettingsScreen();
        },
      ),
    ],

    // =========================================================================
    // Future Authentication Guard
    // =========================================================================
    redirect: (context, state) {
      /*
        Future implementation:

        final authProvider =
            context.read<AuthProvider>();

        final loggedIn =
            authProvider.isAuthenticated;


        final goingToLogin =
            state.matchedLocation ==
            AppRoutes.login;



        if (!loggedIn && !goingToLogin) {

          return AppRoutes.login;

        }



        if (loggedIn && goingToLogin) {

          return AppRoutes.notes;

        }


        return null;

      */

      return null;
    },

    // =========================================================================
    // Unknown Route
    // =========================================================================
    errorBuilder: (context, state) {
      return const _RouteErrorScreen();
    },
  );
}

// ============================================================================
// Invalid Navigation Screen
// ============================================================================

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

// ============================================================================
// 404 Screen
// ============================================================================

final class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),

      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(Icons.error_outline, size: 64),

              SizedBox(height: 16),

              Text(
                '404\n\nThe requested page does not exist.',

                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
