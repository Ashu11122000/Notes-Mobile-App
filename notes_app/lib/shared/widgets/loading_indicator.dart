import 'package:flutter/material.dart';

/// ============================================================================
/// File: loading_indicator.dart
/// ============================================================================
///
/// Enterprise Material 3 loading indicator.
///
/// A lightweight, reusable loading widget that provides a consistent loading
/// experience throughout the application.
///
/// Typical use cases:
///
/// • Login
/// • Registration
/// • Notes loading
/// • Pagination
/// • Data synchronization
/// • Initial application loading
///
/// This widget intentionally remains lightweight and should be used for
/// inline or centered loading states.
///
/// For blocking user interaction, use a dedicated LoadingOverlay.
///
/// Features:
///
/// • Material 3
/// • Adaptive progress indicator
/// • Responsive
/// • Accessible
/// • Theme aware
/// • Lightweight
/// • Reusable
///
/// Example:
///
/// ```dart
/// const LoadingIndicator();
/// ```
///
/// ```dart
/// const LoadingIndicator(
///   message: 'Signing in...',
/// );
/// ```
/// ============================================================================
@immutable
final class LoadingIndicator extends StatelessWidget {
  /// Creates a reusable loading indicator.
  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 36,
    this.strokeWidth = 3,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 320,
    this.color,
    this.textStyle,
  });

  /// Optional loading message.
  final String? message;

  /// Diameter of the loading indicator.
  final double size;

  /// Stroke width of the progress indicator.
  final double strokeWidth;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Maximum content width.
  final double maxWidth;

  /// Optional progress indicator color.
  ///
  /// When null, the current theme color is used.
  final Color? color;

  /// Optional message text style.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message ?? 'Loading',
        child: Padding(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: size,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: strokeWidth,
                    valueColor: color != null
                        ? AlwaysStoppedAnimation<Color>(color!)
                        : null,
                  ),
                ),
                if (message != null && message!.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style:
                        textStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
