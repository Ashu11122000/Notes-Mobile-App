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
/// - Initializes all application services.
/// - Launches the root widget.
/// - Catches any uncaught asynchronous errors.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
/// 1. Flutter Binding
/// 2. Logger
/// 3. Shared Preferences
/// 4. Local Notifications
/// 5. Run Application
///
/// All initialization occurs inside the same Zone to avoid
/// Flutter "Zone mismatch" warnings.
///
/// ============================================================================

Future<void> main() async {
  await runZonedGuarded(
    () async {
      // Initialize Flutter bindings inside the guarded zone.
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize global application services.
      await AppInitializer.initialize();

      // Launch the application.
      runApp(const NotesApp());
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
