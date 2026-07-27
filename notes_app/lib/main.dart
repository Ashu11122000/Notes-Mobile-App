import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
/// • Initializes Flutter.
/// • Initializes global services.
/// • Configures error handling.
/// • Starts application.
///
/// Initialization Order
/// ----------------------------------------------------------------------------
///
/// 1. Flutter Binding
/// 2. Global Error Handlers
/// 3. Application Services
/// 4. Run App
///
/// ============================================================================

Future<void> main() async {
  runZonedGuarded(
    () async {
      // =========================================================================
      // Flutter Binding
      // =========================================================================

      WidgetsFlutterBinding.ensureInitialized();

      // =========================================================================
      // Framework Error Handling
      // =========================================================================

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);

        LoggerService.error(
          'Flutter framework error.',

          error: details.exception,

          stackTrace: details.stack,
        );
      };

      // =========================================================================
      // Async / Platform Error Handling
      // =========================================================================

      PlatformDispatcher.instance.onError =
          (Object error, StackTrace stackTrace) {
            LoggerService.error(
              'Platform error occurred.',

              error: error,

              stackTrace: stackTrace,
            );

            return true;
          };

      // =========================================================================
      // Application Initialization
      // =========================================================================

      try {
        LoggerService.initialize();

        LoggerService.info('Application startup started.');

        await AppInitializer.initialize();

        LoggerService.info('Application services initialized.');

        // =========================================================================
        // Launch Application
        // =========================================================================

        runApp(const NotesApp());
      } catch (exception, stackTrace) {
        LoggerService.error(
          'Application startup failed.',

          error: exception,

          stackTrace: stackTrace,
        );

        // Keep application from silently failing.
        //
        // In production this can be replaced with:
        // - Crashlytics reporting
        // - Sentry reporting
        // - Custom error screen

        runApp(const _StartupErrorApp());
      }
    },

    (Object error, StackTrace stackTrace) {
      LoggerService.error(
        'Unhandled asynchronous error.',

        error: error,

        stackTrace: stackTrace,
      );
    },
  );
}

// ============================================================================
// Startup Error Screen
// ============================================================================
//
// Displayed when application initialization fails.
//
// ============================================================================

final class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(
                  Icons.error_outline_rounded,

                  size: 72,

                  color: Colors.red,
                ),

                const SizedBox(height: 20),

                Text(
                  'Application failed to start.',

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Please restart the application.',

                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
