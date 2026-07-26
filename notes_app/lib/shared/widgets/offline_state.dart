import 'package:flutter/material.dart';

/// ============================================================================
/// File: offline_state.dart
/// ============================================================================
///
/// Enterprise Material 3 offline state widget.
///
/// Displays a polished and reusable UI whenever the application detects that
/// no active internet connection is available.
///
/// Typical use cases:
///
/// • Network unavailable
/// • Internet disconnected
/// • API timeout
/// • Server unreachable
/// • Offline mode
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Responsive
/// • Accessible
/// • Lightweight
/// • Highly reusable
///
/// Example:
///
/// ```dart
/// OfflineState(
///   action: FilledButton(
///     onPressed: retry,
///     child: const Text('Retry'),
///   ),
/// )
/// ```
///
/// A custom illustration can also be provided:
///
/// ```dart
/// OfflineState(
///   illustration: SvgPicture.asset('assets/images/offline.svg'),
/// )
/// ```
/// ============================================================================
@immutable
final class OfflineState extends StatelessWidget {
  /// Creates an enterprise offline state.
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
    this.semanticLabel,
  });

  /// Offline title.
  final String title;

  /// Supporting message.
  final String message;

  /// Icon displayed above the title.
  ///
  /// Ignored when [illustration] is supplied.
  final IconData icon;

  /// Optional custom illustration.
  ///
  /// Allows replacing the default icon with an SVG, Lottie animation,
  /// branded illustration, or any other widget without changing the API.
  final Widget? illustration;

  /// Optional action widget.
  ///
  /// Typical examples:
  ///
  /// • Retry button
  /// • Refresh button
  /// • Open Settings button
  /// • Continue Offline button
  final Widget? action;

  /// Size of the icon.
  final double iconSize;

  /// Maximum content width.
  ///
  /// Prevents the layout from becoming too wide on tablets and desktop.
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
                    Icon(icon, size: iconSize, color: colorScheme.outline),

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
