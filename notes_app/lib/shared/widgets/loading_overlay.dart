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
/// This widget is intended for screen-level or section-level loading during
/// asynchronous operations such as:
///
/// • Login
/// • Registration
/// • Fetching notes
/// • Creating notes
/// • Updating notes
/// • Deleting notes
/// • Synchronization
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Accessible
/// • Responsive
/// • Lightweight
/// • Smooth fade animation
/// • Prevents user interaction
///
/// Example:
///
/// ```dart
/// LoadingOverlay(
///   isLoading: provider.isLoading,
///   message: 'Signing in...',
///   child: const LoginScreen(),
/// )
/// ```
/// ============================================================================
@immutable
final class LoadingOverlay extends StatelessWidget {
  /// Creates a loading overlay.
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

  /// Whether the loading overlay should be displayed.
  final bool isLoading;

  /// Widget displayed beneath the overlay.
  final Widget child;

  /// Optional loading message.
  final String? message;

  /// Overlay opacity.
  final double opacity;

  /// Fade animation duration.
  final Duration animationDuration;

  /// Alignment of the loading indicator.
  final Alignment alignment;

  /// Optional custom barrier color.
  ///
  /// When null, a theme-aware scrim color is used.
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final overlayColor =
        barrierColor ?? theme.colorScheme.scrim.withValues(alpha: opacity);

    return Stack(
      fit: StackFit.expand,
      children: [
        child,

        AnimatedSwitcher(
          duration: animationDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isLoading
              ? Positioned.fill(
                  key: const ValueKey('loading_overlay'),
                  child: RepaintBoundary(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: ColoredBox(
                        color: overlayColor,
                        child: Align(
                          alignment: alignment,
                          child: LoadingIndicator(message: message),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('loading_overlay_hidden')),
        ),
      ],
    );
  }
}
