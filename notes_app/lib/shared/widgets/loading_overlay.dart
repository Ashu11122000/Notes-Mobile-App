import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// ============================================================================
/// File: loading_overlay.dart
/// ============================================================================
///
/// Enterprise Material 3 loading overlay.
///
/// Displays a blocking loading layer above content while an operation
/// is running.
///
/// Common usage:
///
/// - Authentication
/// - Note creation
/// - Note update
/// - Delete operations
/// - Synchronization
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Accessible
/// - Responsive
/// - Optimized rendering
@immutable
final class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.opacity = 0.45,
    this.animationDuration = const Duration(milliseconds: 180),
    this.alignment = Alignment.center,
    this.barrierColor,
    this.loadingIndicator,
  });

  /// Whether loading overlay is visible.
  final bool isLoading;

  /// Screen content.
  final Widget child;

  /// Loading message.
  final String? message;

  /// Overlay opacity.
  final double opacity;

  /// Fade animation duration.
  final Duration animationDuration;

  /// Indicator alignment.
  final Alignment alignment;

  /// Custom overlay color.
  final Color? barrierColor;

  /// Optional custom loading widget.
  final Widget? loadingIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final overlayColor =
        barrierColor ?? theme.colorScheme.scrim.withValues(alpha: opacity);

    return Stack(
      fit: StackFit.expand,

      children: [
        child,

        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: 1,

                duration: animationDuration,

                curve: Curves.easeOutCubic,

                child: RepaintBoundary(
                  child: ExcludeSemantics(
                    excluding: !isLoading,

                    child: ColoredBox(
                      color: overlayColor,

                      child: Align(
                        alignment: alignment,

                        child:
                            loadingIndicator ??
                            LoadingIndicator(message: message),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
