import 'package:flutter/material.dart';

import 'package:notes_app/app/app.dart';
import 'package:notes_app/app/app_initializer.dart';

/// Application entry point.
///
/// Initializes all required application services before
/// launching the root widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initialize();

  runApp(const NotesApp());
}
