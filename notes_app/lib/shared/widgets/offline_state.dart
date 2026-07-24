import 'package:flutter/material.dart';

/// A reusable offline state widget.
///
/// Displays a consistent UI when there is no active internet connection.
///
/// This widget is intentionally generic so it can be reused across
/// Authentication, Notes, Settings, Notifications, and future features.
///
/// Example:
/// ```dart
/// OfflineState(
///   onRetry: _checkConnection,
/// )
/// ```
class OfflineState extends StatelessWidget {
  /// Creates an offline state widget.
  const OfflineState({
    super.key,
    this.title = 'No Internet Connection',
    this.message = 'Please check your internet connection and try again.',
    this.icon = Icons.wifi_off_rounded,
    this.action,
    this.iconSize = 72,
  });

  /// Offline title.
  final String title;

  /// Offline description.
  final String message;

  /// Icon displayed above the title.
  final IconData icon;

  /// Optional action widget.
  ///
  /// Examples:
  /// - RetryButton
  /// - PrimaryButton
  /// - TextButton
  final Widget? action;

  /// Size of the icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: colorScheme.outline),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
