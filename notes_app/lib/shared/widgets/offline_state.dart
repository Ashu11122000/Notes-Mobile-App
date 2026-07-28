import 'package:flutter/material.dart';

/// ============================================================================
/// File: offline_state.dart
/// ============================================================================
///
/// Enterprise Material 3 offline state widget.
///
/// Displays reusable UI when network connectivity is unavailable.
///
/// Designed for:
///
/// - No internet
/// - API timeout
/// - Server unreachable
/// - Offline mode
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Responsive
/// - Accessible
/// - Lightweight
@immutable
final class OfflineState extends StatelessWidget {
  const OfflineState({
    super.key,
    this.title = 'No Internet Connection',
    this.message = 'Please check your internet connection and try again.',
    this.icon = Icons.wifi_off_rounded,
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

  /// Offline title.
  final String title;

  /// Offline description.
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
                        color: colorScheme.surfaceContainerHighest,

                        borderRadius: BorderRadius.circular(iconSize * .35),
                      ),

                      child: Icon(
                        icon,

                        size: iconSize,

                        color: colorScheme.onSurfaceVariant,
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
