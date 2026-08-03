import 'package:flutter/material.dart';

/// ============================================================================
/// File: error_state.dart
/// ============================================================================
///
/// Enterprise Material 3 error state widget.
///
/// Displays reusable error feedback UI for failed operations.
///
/// Typical usage:
///
/// - Network failures
/// - API errors
/// - Permission issues
/// - Loading failures
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Responsive
/// - Accessible
/// - Lightweight
@immutable
final class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline_rounded,
    this.illustration,
    this.action,
    this.iconSize = 72,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.all(24),
    this.titleSpacing = 24,
    this.messageSpacing = 12,
    this.actionSpacing = 28,
    this.textAlign = TextAlign.center,
    this.semanticLabel,
  });

  /// Error title.
  final String title;

  /// Error description.
  final String message;

  /// Default icon.
  final IconData icon;

  /// Custom illustration.
  final Widget? illustration;

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

    return Center(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: semanticLabel ?? '$title. $message',

        child: Padding(
          padding: padding,

          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                illustration ??
                    Container(
                      width: iconSize * 1.35,
                      height: iconSize * 1.35,

                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,

                        borderRadius: BorderRadius.circular(iconSize * .35),
                      ),

                      child: Icon(
                        icon,

                        size: iconSize,

                        color: colorScheme.onErrorContainer,
                      ),
                    ),

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
