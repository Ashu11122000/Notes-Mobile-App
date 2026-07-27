import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/settings/presentation/providers/settings_provider.dart';

import 'app_providers.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// ============================================================================
/// File: app.dart
/// ============================================================================
///
/// Root Application Widget
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Registers dependency providers.
/// • Configures MaterialApp.router.
/// • Applies theme system.
/// • Handles global UI configuration.
/// • Connects application routing.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Handle business logic.
/// • Call APIs.
/// • Manage feature state.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
/// main.dart
///     ↓
/// NotesApp
///     ↓
/// AppProviders
///     ↓
/// Feature Providers
///
/// ============================================================================

final class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp.router(
            // =================================================================
            // Application Metadata
            // =================================================================
            title: 'Notes App',

            debugShowCheckedModeBanner: false,

            restorationScopeId: 'notes_app',

            // =================================================================
            // Theme Configuration
            // =================================================================
            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            themeMode: settingsProvider.themeMode,

            themeAnimationDuration: const Duration(milliseconds: 300),

            themeAnimationCurve: Curves.easeInOutCubic,

            // =================================================================
            // Router
            // =================================================================
            routerConfig: AppRouter.router,

            // =================================================================
            // Global Application Builder
            // =================================================================
            builder: (context, child) {
              return _AppWrapper(child: child ?? const SizedBox.shrink());
            },
          );
        },
      ),
    );
  }
}

/// ============================================================================
///
/// Global Application Wrapper
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Handles global gestures.
/// • Dismisses keyboard.
/// • Provides accessibility configuration.
/// • Keeps MaterialApp clean.
///
/// ============================================================================

final class _AppWrapper extends StatelessWidget {
  const _AppWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onTap: _dismissKeyboard,

      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          // Prevents extreme text scaling
          // from breaking UI layouts.
          textScaler: const TextScaler.linear(1.0),
        ),

        child: child,
      ),
    );
  }

  // ===========================================================================
  // Keyboard Handling
  // ===========================================================================

  void _dismissKeyboard() {
    final FocusManager focusManager = FocusManager.instance;

    final FocusNode? primaryFocus = focusManager.primaryFocus;

    if (primaryFocus != null) {
      primaryFocus.unfocus();
    }
  }
}
