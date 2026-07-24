import 'package:flutter/material.dart';

import 'app_providers.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// Root widget of the Notes application.
///
/// Responsibilities:
/// - Register global providers
/// - Configure MaterialApp.router
/// - Apply application theme
/// - Configure application routing
///
/// Business logic should never be placed here.
class NotesApp extends StatelessWidget {
  /// Creates the root application widget.
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        // ---------------------------------------------------------------------
        // General
        // ---------------------------------------------------------------------
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'notes_app',

        // ---------------------------------------------------------------------
        // Theme
        // ---------------------------------------------------------------------
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        themeAnimationDuration: const Duration(milliseconds: 250),
        themeAnimationCurve: Curves.easeInOut,

        // ---------------------------------------------------------------------
        // Routing
        // ---------------------------------------------------------------------
        routerConfig: AppRouter.router,

        // ---------------------------------------------------------------------
        // Global Builder
        // ---------------------------------------------------------------------
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
