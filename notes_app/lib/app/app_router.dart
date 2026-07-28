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
/// • Centralized navigation.
/// • Route validation.
/// • Unknown route handling.
/// • Authentication guard ready.
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

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,

    initialLocation: AppRoutes.splash,

    debugLogDiagnostics: kDebugMode,

    routes: <RouteBase>[
      // =======================================================================
      // AUTH
      // =======================================================================
      GoRoute(
        name: AppRoutes.splashName,

        path: AppRoutes.splash,

        builder: (_, __) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        name: AppRoutes.loginName,

        path: AppRoutes.login,

        builder: (_, __) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        name: AppRoutes.registerName,

        path: AppRoutes.register,

        builder: (_, __) {
          return const RegisterScreen();
        },
      ),

      // =======================================================================
      // NOTES
      // =======================================================================
      GoRoute(
        name: AppRoutes.notesName,

        path: AppRoutes.notes,

        builder: (_, __) {
          return const NotesScreen();
        },
      ),

      GoRoute(
        name: AppRoutes.addNoteName,

        path: AppRoutes.addNote,

        builder: (_, __) {
          return const AddNoteScreen();
        },
      ),

      GoRoute(
        name: AppRoutes.editNoteName,

        path: AppRoutes.editNote,

        builder: (_, state) {
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
        name: AppRoutes.noteDetailName,

        path: AppRoutes.noteDetail,

        builder: (_, state) {
          final Object? extra = state.extra;

          if (extra is! Note) {
            return const _InvalidNavigationScreen(
              message: 'Unable to open note.\nInvalid note data.',
            );
          }

          return NoteDetailScreen(note: extra);
        },
      ),

      // =======================================================================
      // SETTINGS
      // =======================================================================
      GoRoute(
        name: AppRoutes.settingsName,

        path: AppRoutes.settings,

        builder: (_, __) {
          return const SettingsScreen();
        },
      ),

      GoRoute(
        name: AppRoutes.notificationSettingsName,

        path: AppRoutes.notificationSettings,

        builder: (_, __) {
          return const NotificationSettingsScreen();
        },
      ),
    ],

    // =======================================================================
    // AUTH REDIRECT
    // =======================================================================
    redirect: (_, state) {
      /*
      
      Future:

      final auth =
          context.read<AuthProvider>();

      final loggedIn =
          auth.isAuthenticated;


      final location =
          state.matchedLocation;


      if (!loggedIn &&
          location != AppRoutes.login) {

        return AppRoutes.login;
      }


      if (loggedIn &&
          location == AppRoutes.login) {

        return AppRoutes.notes;
      }


      */

      return null;
    },

    // =======================================================================
    // ERROR HANDLING
    // =======================================================================
    errorBuilder: (_, __) {
      return const _RouteErrorScreen();
    },
  );
}

// ============================================================================
// Invalid Navigation
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
// Route Error
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

            children: <Widget>[
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
