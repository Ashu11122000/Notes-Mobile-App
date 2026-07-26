import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';

/// ============================================================================
/// File: custom_snack_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 snackbar helper.
///
/// Centralizes snackbar presentation across the application, providing a
/// consistent look, accessibility, and behavior.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Responsive
/// - Floating appearance
/// - Optional action button
/// - Lightweight
///
/// Typical use cases:
///
/// - Login success
/// - Registration
/// - CRUD operations
/// - Network errors
/// - Validation
/// - Session expiration
/// ============================================================================
abstract final class CustomSnackBar {
  /// Displays a snackbar.
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool hideCurrent = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (
      Color backgroundColor,
      Color foregroundColor,
      IconData icon,
    ) = switch (type) {
      SnackbarType.success => (
        Colors.green.shade700,
        Colors.white,
        Icons.check_circle_rounded,
      ),
      SnackbarType.info => (
        colorScheme.inverseSurface,
        colorScheme.onInverseSurface,
        Icons.info_rounded,
      ),
      SnackbarType.warning => (
        Colors.orange.shade700,
        Colors.white,
        Icons.warning_amber_rounded,
      ),
      SnackbarType.error => (
        colorScheme.error,
        colorScheme.onError,
        Icons.error_rounded,
      ),
    };

    final messenger = ScaffoldMessenger.of(context);

    if (hideCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: backgroundColor,
        action: action,
        elevation: 2,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Semantics(
          liveRegion: true,
          child: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hides the currently visible snackbar.
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Removes all queued snackbar.
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
