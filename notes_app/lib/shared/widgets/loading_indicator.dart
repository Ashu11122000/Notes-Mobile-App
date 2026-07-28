import 'package:flutter/material.dart';

/// ============================================================================
/// File: loading_indicator.dart
/// ============================================================================
///
/// Enterprise Material 3 loading indicator.
///
/// Provides a reusable loading experience across the application.
///
/// Supported use cases:
///
/// - Authentication
/// - Notes loading
/// - Pagination
/// - Synchronization
/// - Initial app startup
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Accessible
/// - Lightweight
/// - Responsive
enum LoadingIndicatorType {
  /// Circular progress indicator.
  circular,

  /// Linear progress indicator.
  linear,
}

@immutable
final class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.message,
    this.type = LoadingIndicatorType.circular,
    this.size = 36,
    this.strokeWidth = 3,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 320,
    this.minHeight,
    this.color,
    this.textStyle,
  });

  /// Optional loading message.
  final String? message;

  /// Loading indicator type.
  final LoadingIndicatorType type;

  /// Circular indicator diameter.
  final double size;

  /// Circular stroke width.
  final double strokeWidth;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Maximum content width.
  final double maxWidth;

  /// Optional minimum height.
  final double? minHeight;

  /// Optional indicator color.
  final Color? color;

  /// Message style.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final indicatorColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: message ?? 'Loading',

        child: Padding(
          padding: padding,

          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minHeight: minHeight ?? 0,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                switch (type) {
                  LoadingIndicatorType.circular => SizedBox.square(
                    dimension: size,

                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: strokeWidth,

                      valueColor: AlwaysStoppedAnimation(indicatorColor),
                    ),
                  ),

                  LoadingIndicatorType.linear => SizedBox(
                    width: double.infinity,

                    child: LinearProgressIndicator(color: indicatorColor),
                  ),
                },

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
