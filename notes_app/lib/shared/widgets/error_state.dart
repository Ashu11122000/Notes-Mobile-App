import 'package:flutter/material.dart';

/// ============================================================================
/// File: error_state.dart
/// ============================================================================
///
/// Enterprise Material 3 error state widget.
///
/// Displays a polished and reusable UI whenever an operation fails.
///
/// Typical use cases:
///
/// • Network errors
/// • API failures
/// • Server errors
/// • Permission denied
/// • Unexpected exceptions
/// • Loading failures
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Responsive
/// • Accessible
/// • Lightweight
/// • Reusable
///
/// Example:
///
/// ```dart
/// ErrorState(
///   title: 'Something went wrong',
///   message: 'Unable to load your notes.',
///   action: FilledButton(
///     onPressed: retry,
///     child: const Text('Retry'),
///   ),
/// )
/// ```
///
/// You may also replace the default icon with a custom illustration:
///
/// ```dart
/// ErrorState(
///   title: 'No Connection',
///   message: 'Please check your internet connection.',
///   illustration: Icon(Icons.wifi_off_rounded),
/// )
/// ```
@immutable
final class ErrorState extends StatelessWidget {
  /// Creates an enterprise error state.
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
    this.semanticLabel,
  });

  /// Error title.
  final String title;

  /// Supporting error message.
  final String message;

  /// Icon displayed above the title.
  ///
  /// Ignored when [illustration] is supplied.
  final IconData icon;

  /// Optional custom illustration.
  ///
  /// This allows future SVGs, Lottie animations or branded illustrations
  /// without changing the widget API.
  final Widget? illustration;

  /// Optional action widget.
  ///
  /// Examples:
  ///
  /// • Retry button
  /// • Refresh button
  /// • Login button
  /// • Contact support button
  final Widget? action;

  /// Size of the icon.
  final double iconSize;

  /// Maximum width on larger screens.
  final double maxWidth;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Semantics(
        container: true,
        liveRegion: true,
        label: semanticLabel ?? title,
        child: Padding(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                illustration ??
                    Icon(icon, size: iconSize, color: colorScheme.error),

                const SizedBox(height: 24),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),

                if (action != null) ...[const SizedBox(height: 28), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
