import 'package:flutter/material.dart';

/// Registers all global providers used by the application.
///
/// This widget serves as the root dependency injection container
/// for the application.
///
/// As new features are implemented, their providers should be
/// registered here.
///
/// Current:
/// - No global providers
///
/// Future:
/// - AuthProvider
/// - NotesProvider
/// - NotificationProvider
/// - SettingsProvider
class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}