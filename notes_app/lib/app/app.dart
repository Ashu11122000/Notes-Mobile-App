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
/// Root widget of the Notes application.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Registers global providers.
/// - Configures MaterialApp.router.
/// - Applies application theme.
/// - Responds to theme changes.
/// - Configures application routing.
///
/// Business logic should never be placed here.
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
            // -----------------------------------------------------------------
            // General
            // -----------------------------------------------------------------
            title: 'Notes App',
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'notes_app',

            // -----------------------------------------------------------------
            // Theme
            // -----------------------------------------------------------------
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,

            themeAnimationDuration: const Duration(milliseconds: 250),
            themeAnimationCurve: Curves.easeInOut,

            // -----------------------------------------------------------------
            // Routing
            // -----------------------------------------------------------------
            routerConfig: AppRouter.router,

            // -----------------------------------------------------------------
            // Global Builder
            // -----------------------------------------------------------------
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
