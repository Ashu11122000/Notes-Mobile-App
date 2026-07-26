import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_dialog.dart
/// ============================================================================
///
/// Enterprise Material 3 dialog helper.
///
/// This utility centralizes dialog presentation across the application,
/// ensuring a consistent appearance, behavior, and accessibility.
///
/// Typical use cases include:
///
/// - Logout confirmation
/// - Delete confirmation
/// - Network errors
/// - Permission requests
/// - Session expiration
/// - Informational messages
///
/// The helper intentionally wraps Flutter's dialog APIs rather than replacing
/// them, providing a lightweight and reusable abstraction.
///
/// All dialogs automatically:
///
/// - Follow Material 3
/// - Respect the active theme
/// - Remain responsive
/// - Support accessibility
/// - Scale well across phones and tablets
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
    IconData? icon,
    bool isDestructive = false,
    bool useRootNavigator = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          icon: icon != null ? Icon(icon) : null,
          title: Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelText),
            ),
            FilledButton(
              style: isDestructive
                  ? FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    )
                  : null,
              onPressed: () => Navigator.of(dialogContext).pop(true),
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
    IconData? icon,
    bool useRootNavigator = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (dialogContext) {
        return AlertDialog(
          icon: icon != null ? Icon(icon) : null,
          title: Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Text(message),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
