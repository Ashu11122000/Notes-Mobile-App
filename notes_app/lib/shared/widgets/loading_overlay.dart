import 'package:flutter/material.dart';

import 'loading_indicator.dart';

/// A reusable loading overlay.
///
/// Displays a modal loading indicator above its child while preventing
/// user interaction.
///
/// This widget is intended to wrap an entire screen or a section of the UI
/// during asynchronous operations.
///
/// Example:
/// ```dart
/// LoadingOverlay(
///   isLoading: provider.isLoading,
///   child: const LoginScreen(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Creates a loading overlay.
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.opacity = 0.45,
  });

  /// Whether the loading overlay should be displayed.
  final bool isLoading;

  /// Widget displayed beneath the overlay.
  final Widget child;

  /// Optional loading message.
  final String? message;

  /// Background opacity.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: ColoredBox(
                color: Colors.black.withValues(alpha: opacity),
                child: LoadingIndicator(message: message),
              ),
            ),
          ),
      ],
    );
  }
}
