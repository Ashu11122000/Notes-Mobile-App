import 'package:flutter/material.dart';

/// ============================================================================
/// File: section_header.dart
/// ============================================================================
///
/// Enterprise Material 3 section header.
///
/// Lightweight reusable heading component for grouping application content.
///
/// Used across:
///
/// - Notes
/// - Dashboard
/// - Settings
/// - Profile
/// - Analytics
///
/// Features:
///
/// - Material 3
/// - Responsive
/// - Accessible
/// - Lightweight
/// - Theme aware
@immutable
final class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.semanticLabel,
    this.dense = false,
  });

  /// Section title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional trailing action.
  final Widget? trailing;

  /// Optional leading icon.
  final IconData? icon;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Title color.
  final Color? titleColor;

  /// Subtitle color.
  final Color? subtitleColor;

  /// Icon color.
  final Color? iconColor;

  /// Accessibility label.
  final String? semanticLabel;

  /// Compact layout.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    final text = theme.textTheme;

    final titleSpacing = dense ? 4.0 : 6.0;

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

                child: Icon(icon, size: 22, color: iconColor ?? colors.primary),
              ),

              SizedBox(width: dense ? 8 : 12),
            ],

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,

                      letterSpacing: -0.2,

                      color: titleColor,
                    ),
                  ),

                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    SizedBox(height: titleSpacing),

                    Text(
                      subtitle!,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: text.bodyMedium?.copyWith(
                        color: subtitleColor ?? colors.onSurfaceVariant,

                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (trailing != null) ...[
              SizedBox(width: dense ? 8 : 16),

              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
