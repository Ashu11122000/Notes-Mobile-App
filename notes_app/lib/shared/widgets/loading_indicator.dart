import 'package:flutter/material.dart';

/// A reusable Material 3 loading indicator.
///
/// This widget displays a centered loading spinner with an optional
/// message below it.
///
/// It is intentionally lightweight and reusable across the application.
///
/// For full-screen loading, use [LoadingOverlay] instead.
///
/// Example:
/// ```dart
/// const LoadingIndicator();
/// ```
///
/// ```dart
/// const LoadingIndicator(
///   message: 'Signing in...',
/// )
/// ```
class LoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator.
  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 36,
    this.strokeWidth = 3,
  });

  /// Optional loading message.
  final String? message;

  /// Diameter of the loading indicator.
  final double size;

  /// Stroke width of the progress indicator.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(strokeWidth: strokeWidth),
          ),
          if (message != null && message!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
