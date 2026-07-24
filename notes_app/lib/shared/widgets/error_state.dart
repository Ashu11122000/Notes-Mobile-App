import 'package:flutter/material.dart';

/// A reusable error state widget.
///
/// Displays a consistent UI when an operation fails.
///
/// This widget is intentionally generic so it can be reused across
/// Authentication, Notes, Settings, Notifications, and future features.
///
/// Example:
/// ```dart
/// ErrorState(
///   title: 'Something went wrong',
///   message: 'Unable to load your notes.',
///   onRetry: _loadNotes,
/// )
/// ```
class ErrorState extends StatelessWidget {
  /// Creates an error state widget.
  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline_rounded,
    this.action,
    this.iconSize = 72,
  });

  /// Error title.
  final String title;

  /// Detailed error message.
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
            Icon(icon, size: iconSize, color: colorScheme.error),
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
