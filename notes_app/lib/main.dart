import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';
import 'core/services/logger_service.dart';

/// ============================================================================
/// File: main.dart
/// ============================================================================
///
/// Application Entry Point
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Initializes Flutter bindings.
/// - Initializes global application services.
/// - Launches the root widget.
/// - Captures uncaught asynchronous errors.
/// - Logs startup failures.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
/// 1. Flutter Binding
/// 2. Logger
/// 3. Shared Preferences
/// 4. Local Notifications
/// 5. Run Application
///
/// All initialization occurs inside the same Zone to avoid Flutter
/// "Zone mismatch" warnings.
///
/// ============================================================================

Future<void> main() async {
  runZonedGuarded(
    () async {
      try {
        // ---------------------------------------------------------------------
        // Flutter Binding
        // ---------------------------------------------------------------------

        WidgetsFlutterBinding.ensureInitialized();

        // ---------------------------------------------------------------------
        // Initialize global services
        // ---------------------------------------------------------------------

        await AppInitializer.initialize();

        LoggerService.info('Application initialized successfully.');

        // ---------------------------------------------------------------------
        // Launch Application
        // ---------------------------------------------------------------------

        runApp(const NotesApp());
      } catch (exception, stackTrace) {
        LoggerService.error(
          'Application startup failed.',
          error: exception,
          stackTrace: stackTrace,
        );

        rethrow;
      }
    },
    (Object error, StackTrace stackTrace) {
      LoggerService.error(
        'Unhandled application error.',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
