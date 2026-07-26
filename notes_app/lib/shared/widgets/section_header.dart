import 'package:flutter/material.dart';

/// ============================================================================
/// File: section_header.dart
/// ============================================================================
///
/// Enterprise Material 3 section header.
///
/// A lightweight and reusable section header used throughout the application
/// to separate logical groups of content.
///
/// Typical use cases:
///
/// • Notes
/// • Dashboard
/// • Settings
/// • Profile
/// • Analytics
/// • Notifications
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Responsive
/// • Accessible
/// • Lightweight
/// • Reusable
///
/// Example:
///
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
///
/// Example with icon:
///
/// ```dart
/// SectionHeader(
///   icon: Icons.note_alt_outlined,
///   title: 'Notes',
/// )
/// ```
/// ============================================================================
@immutable
final class SectionHeader extends StatelessWidget {
  /// Creates a reusable section header.
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.titleColor,
    this.subtitleColor,
    this.semanticLabel,
  });

  /// Primary section title.
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional trailing widget.
  ///
  /// Examples:
  ///
  /// • TextButton
  /// • IconButton
  /// • PopupMenuButton
  /// • Switch
  final Widget? trailing;

  /// Optional leading icon.
  final IconData? icon;

  /// Padding around the section header.
  final EdgeInsetsGeometry padding;

  /// Optional title color.
  final Color? titleColor;

  /// Optional subtitle color.
  final Color? subtitleColor;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      header: true,
      label: semanticLabel ?? title,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  icon,
                  size: 22,
                  color: titleColor ?? colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
            ],

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: titleColor,
                    ),
                  ),

                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: subtitleColor ?? colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: 16),
              Flexible(flex: 0, child: trailing!),
            ],
          ],
        ),
      ),
    );
  }
}
