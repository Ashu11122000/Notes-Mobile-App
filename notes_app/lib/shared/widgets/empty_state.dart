import 'package:flutter/material.dart';

/// A reusable empty state widget.
///
/// Displays a consistent UI when there is no content to show.
///
/// This widget is intentionally generic so it can be reused across
/// Authentication, Notes, Settings, Notifications, and future features.
///
/// Example:
/// ```dart
/// const EmptyState(
///   icon: Icons.note_alt_outlined,
///   title: 'No Notes',
///   message: 'Create your first note to get started.',
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates an empty state widget.
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.iconSize = 72,
  });

  /// Icon displayed above the title.
  final IconData icon;

  /// Primary title.
  final String title;

  /// Supporting message.
  final String message;

  /// Optional action widget.
  ///
  /// Examples:
  /// - Retry button
  /// - Create note button
  /// - Refresh button
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
