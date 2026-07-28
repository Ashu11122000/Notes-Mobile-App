import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_dialog.dart
/// ============================================================================
///
/// Enterprise Material 3 dialog helper.
///
/// Centralizes dialog presentation across the application to ensure consistent
/// appearance, accessibility, and behavior.
///
/// Typical use cases:
///
/// - Logout confirmation
/// - Delete confirmation
/// - Network errors
/// - Permission requests
/// - Session expiration
/// - Informational messages
///
/// This helper wraps Flutter's native dialog APIs while keeping the application
/// UI consistent and maintainable.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Responsive
/// - Accessible
/// - Tablet friendly
/// - Lightweight
abstract final class CustomDialog {
  static const double _maxWidth = 420;

  /// Displays a confirmation dialog.
  ///
  /// Returns:
  ///
  /// - `true` when confirmed.
  /// - `false` when cancelled or dismissed.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool requestFocus = true,
    IconData? icon,
    bool isDestructive = false,
    String? semanticLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          semanticLabel: semanticLabel,
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          icon: icon != null ? Icon(icon) : null,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(cancelText),
            ),
            FilledButton(
              style: isDestructive
                  ? FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    )
                  : null,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Displays an informational dialog.
  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool requestFocus = true,
    IconData? icon,
    String? semanticLabel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      requestFocus: requestFocus,
      builder: (dialogContext) {
        return AlertDialog(
          semanticLabel: semanticLabel,
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          icon: icon != null ? Icon(icon) : null,
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
