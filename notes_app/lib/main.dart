import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';
import 'core/services/logger_service.dart';

/// Application entry point.
///
/// Initializes all required application services before
/// launching the root widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(
    () async {
      await AppInitializer.initialize();

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
