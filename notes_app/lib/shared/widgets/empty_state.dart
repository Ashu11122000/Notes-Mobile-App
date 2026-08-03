import 'package:flutter/material.dart';

/// ============================================================================
/// File: empty_state.dart
/// ============================================================================
///
/// Enterprise Material 3 empty state widget.
///
/// Displays a reusable empty content state.
///
/// Designed for:
///
/// - Notes
/// - Search results
/// - Notifications
/// - Offline states
/// - Dashboards
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Responsive
/// - Accessible
/// - Lightweight
@immutable
final class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    required this.message,
    this.action,
    this.iconSize = 72,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.all(24),
    this.titleSpacing = 24,
    this.messageSpacing = 12,
    this.actionSpacing = 28,
    this.textAlign = TextAlign.center,
    this.semanticLabel,
  }) : assert(
         icon != null || illustration != null,
         'Either icon or illustration must be provided.',
       );

  /// Default icon.
  final IconData? icon;

  /// Custom illustration widget.
  final Widget? illustration;

  /// Main title.
  final String title;

  /// Description.
  final String message;

  /// Optional action.
  final Widget? action;

  /// Icon size.
  final double iconSize;

  /// Maximum content width.
  final double maxWidth;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Space between icon and title.
  final double titleSpacing;

  /// Space between title and message.
  final double messageSpacing;

  /// Space before action.
  final double actionSpacing;

  /// Text alignment.
  final TextAlign textAlign;

  /// Accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final effectiveLabel = semanticLabel ?? '$title. $message';

    return Center(
      child: Semantics(
        container: true,
        label: effectiveLabel,

        child: Padding(
          padding: padding,

          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                illustration ??
                    Icon(icon, size: iconSize, color: colorScheme.primary),

                SizedBox(height: titleSpacing),

                Text(
                  title,
                  textAlign: textAlign,

                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,

                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: messageSpacing),

                Text(
                  message,
                  textAlign: textAlign,

                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,

                    height: 1.5,
                  ),
                ),

                if (action != null) ...[
                  SizedBox(height: actionSpacing),

                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
