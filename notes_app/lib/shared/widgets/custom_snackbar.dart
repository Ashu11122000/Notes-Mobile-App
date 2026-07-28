import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';

/// ============================================================================
/// File: custom_snack_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 snackbar helper.
///
/// Centralizes snackbar presentation across the application.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Responsive
/// - Floating appearance
/// - Optional actions
/// - Lightweight
abstract final class CustomSnackBar {
  /// Maximum snackbar width on large screens.
  static const double _maxWidth = 600;

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
    final style = _resolveStyle(theme, type);

    final messenger = ScaffoldMessenger.of(context);

    if (hideCurrent) {
      messenger.hideCurrentSnackBar();
    }

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: style.backgroundColor,
        elevation: 2,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: action == null
            ? null
            : SnackBarAction(
                label: action.label,
                onPressed: action.onPressed,
                textColor: style.foregroundColor,
              ),
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  Icon(style.icon, color: style.foregroundColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: style.foregroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hides current snackbar.
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Removes queued snackbars.
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static _SnackBarStyle _resolveStyle(ThemeData theme, SnackbarType type) {
    final colorScheme = theme.colorScheme;

    return switch (type) {
      SnackbarType.success => _SnackBarStyle(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        icon: Icons.check_circle_rounded,
      ),

      SnackbarType.info => _SnackBarStyle(
        backgroundColor: colorScheme.inverseSurface,
        foregroundColor: colorScheme.onInverseSurface,
        icon: Icons.info_rounded,
      ),

      SnackbarType.warning => _SnackBarStyle(
        backgroundColor: colorScheme.tertiaryContainer,
        foregroundColor: colorScheme.onTertiaryContainer,
        icon: Icons.warning_amber_rounded,
      ),

      SnackbarType.error => _SnackBarStyle(
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
        icon: Icons.error_rounded,
      ),
    };
  }
}

@immutable
final class _SnackBarStyle {
  const _SnackBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
}
