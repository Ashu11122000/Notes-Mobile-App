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
/// • Connects routing.
/// • Provides global UI configuration.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Handle business logic.
/// • Call APIs.
/// • Manage feature state.
///
/// ============================================================================

final class NotesApp extends StatelessWidget {

  // Private constructor to prevent instantiation of the class.
  // {super.key} is a named parameter that is used to pass the key to the superclass constructor.
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Selector<SettingsProvider, ThemeMode>(
        selector: (context, settingsProvider) {
          return settingsProvider.themeMode;
        },

        builder: (context, themeMode, child) {
          return MaterialApp.router(
            // =================================================================
            // Metadata
            // =================================================================
            title: 'Notes App',

            debugShowCheckedModeBanner: false,

            restorationScopeId: 'notes_app',

            // =================================================================
            // Theme
            // =================================================================
            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            themeMode: themeMode,

            themeAnimationDuration: const Duration(milliseconds: 200),

            themeAnimationCurve: Curves.easeOut,

            // =================================================================
            // Routing
            // =================================================================
            routerConfig: AppRouter.router,

            // =================================================================
            // Global Wrapper
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
/// • Keyboard dismissal.
/// • Accessibility configuration.
/// • Global UI behavior.
///
/// ============================================================================

final class _AppWrapper extends StatelessWidget {
  const _AppWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextScaler textScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onTap: _dismissKeyboard,

      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),

        child: child,
      ),
    );
  }

  // ===========================================================================
  // Keyboard Handling
  // ===========================================================================

  void _dismissKeyboard() {
    final FocusNode? focusNode = FocusManager.instance.primaryFocus;

    focusNode?.unfocus();
  }
}
