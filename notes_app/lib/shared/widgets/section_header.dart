import 'package:flutter/material.dart';

/// A reusable section header.
///
/// Displays a section title with an optional subtitle and trailing widget.
///
/// This widget is intentionally generic so it can be reused throughout
/// the application.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'Recent Notes',
///   subtitle: '12 notes',
///   trailing: TextButton(
///     onPressed: () {},
///     child: const Text('View All'),
///   ),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Creates a section header.
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  /// Primary section title.
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional trailing widget.
  ///
  /// Examples:
  /// - TextButton
  /// - IconButton
  /// - PopupMenuButton
  final Widget? trailing;

  /// Padding around the section header.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 16), trailing!],
        ],
      ),
    );
  }
}
