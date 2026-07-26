import 'package:flutter/material.dart';

/// ============================================================================
/// File: empty_state.dart
/// ============================================================================
///
/// Enterprise Material 3 empty state widget.
///
/// Displays a polished, reusable empty state when no content is available.
///
/// Typical use cases:
///
/// • No notes
/// • No search results
/// • No notifications
/// • No internet
/// • Empty favorites
/// • Empty dashboard
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
/// const EmptyState(
///   icon: Icons.note_alt_outlined,
///   title: 'No Notes',
///   message: 'Create your first note to get started.',
/// )
/// ```
///
/// You may also replace the default icon with a custom illustration:
///
/// ```dart
/// EmptyState(
///   title: 'No Internet',
///   message: 'Please check your connection.',
///   illustration: Icon(Icons.wifi_off_rounded),
/// )
/// ```
@immutable
final class EmptyState extends StatelessWidget {
  /// Creates an enterprise empty state.
  const EmptyState({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    required this.message,
    this.action,
    this.iconSize = 72,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.all(24),
    this.semanticLabel,
  }) : assert(
         icon != null || illustration != null,
         'Either icon or illustration must be provided.',
       );

  /// Icon displayed above the title.
  ///
  /// Ignored when [illustration] is supplied.
  final IconData? icon;

  /// Optional custom illustration.
  ///
  /// Allows replacing the icon with an SVG, Lottie, image,
  /// or any custom widget without changing the public API.
  final Widget? illustration;

  /// Primary title.
  final String title;

  /// Supporting description.
  final String message;

  /// Optional action widget.
  ///
  /// Examples:
  ///
  /// • Retry button
  /// • Create note button
  /// • Refresh button
  /// • Login button
  final Widget? action;

  /// Size of the icon.
  final double iconSize;

  /// Maximum width on large screens.
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
