import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';

/// A reusable helper for displaying Material 3 snackbars.
///
/// This class centralizes snackbar presentation across the application,
/// ensuring consistent colors, icons, and behavior.
///
/// Example:
/// ```dart
/// CustomSnackBar.show(
///   context,
///   message: 'Login successful.',
///   type: SnackbarType.success,
/// );
/// ```
abstract final class CustomSnackBar {
  /// Displays a snackbar.
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final (backgroundColor, foregroundColor, icon) = switch (type) {
      SnackbarType.success => (
        Colors.green,
        Colors.white,
        Icons.check_circle_rounded,
      ),
      SnackbarType.info => (
        colorScheme.primary,
        colorScheme.onPrimary,
        Icons.info_rounded,
      ),
      SnackbarType.warning => (
        Colors.orange,
        Colors.white,
        Icons.warning_rounded,
      ),
      SnackbarType.error => (
        colorScheme.error,
        colorScheme.onError,
        Icons.error_rounded,
      ),
    };

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          content: Row(
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: TextStyle(color: foregroundColor)),
              ),
            ],
          ),
        ),
      );
  }

  /// Hides the currently visible snackbar, if any.
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Removes all queued snackbars.
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
