import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// ============================================================================
/// File: loading_overlay.dart
/// ============================================================================
///
/// Enterprise Material 3 loading overlay.
///
/// Displays a modal loading indicator above its child while preventing user
/// interaction.
///
/// Features:
///
/// • Material 3 compatible
/// • Theme aware
/// • Accessible
/// • Responsive
/// • Smooth fade animation
/// • Prevents user interaction
///
/// ============================================================================

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
  });

  /// Whether loading overlay is visible.
  final bool isLoading;

  /// Main screen content.
  final Widget child;

  /// Optional loading message.
  final String? message;

  /// Overlay opacity.
  final double opacity;

  /// Fade animation duration.
  final Duration animationDuration;

  /// Loading indicator alignment.
  final Alignment alignment;

  /// Custom overlay color.
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color overlayColor =
        barrierColor ?? theme.colorScheme.scrim.withValues(alpha: opacity);

    return Stack(
      fit: StackFit.expand,

      children: [
        // ---------------------------------------------------------------------
        // Screen Content
        // ---------------------------------------------------------------------
        child,

        // ---------------------------------------------------------------------
        // Loading Layer
        // ---------------------------------------------------------------------
        IgnorePointer(
          ignoring: !isLoading,

          child: AnimatedOpacity(
            duration: animationDuration,

            curve: Curves.easeOutCubic,

            opacity: isLoading ? 1 : 0,

            child: RepaintBoundary(
              child: ColoredBox(
                color: overlayColor,

                child: Align(
                  alignment: alignment,

                  child: LoadingIndicator(message: message),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
