import 'package:flutter/material.dart';

/// =============================================================================
/// File: app_bar_title.dart
/// =============================================================================
///
/// A reusable Material 3 app bar title.
///
/// This widget provides a consistent, accessible, and theme-aware title for
/// application app bars. It centralizes typography and styling to ensure a
/// uniform appearance across all screens while remaining lightweight and
/// highly reusable.
///
/// Features:
///
/// - Material 3 typography
/// - Theme-aware styling
/// - Accessibility support
/// - Tooltip for truncated titles
/// - Optional custom text style
/// - Smooth title transitions
///
/// Example:
///
/// ```dart
/// AppBar(
///   title: const AppBarTitle('Login'),
/// )
/// ```
///
/// ```dart
/// SliverAppBar(
///   title: const AppBarTitle('My Notes'),
/// )
/// ```
@immutable
final class AppBarTitle extends StatelessWidget {
  /// Creates an app bar title.
  const AppBarTitle(
    this.title, {
    super.key,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.style,
    this.tooltip,
  });

  /// Title text displayed in the app bar.
  final String title;

  /// Alignment of the title text.
  final TextAlign textAlign;

  /// Maximum number of text lines.
  final int maxLines;

  /// Overflow behavior.
  final TextOverflow overflow;

  /// Optional custom text style.
  ///
  /// When omitted, the widget uses the application's Material 3 typography.
  final TextStyle? style;

  /// Optional tooltip.
  ///
  /// Defaults to the title when omitted.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleLarge;

    return Semantics(
      header: true,
      child: Tooltip(
        message: tooltip ?? title,
        waitDuration: const Duration(milliseconds: 500),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            title,
            key: ValueKey(title),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            style:
                style ??
                defaultStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
          ),
        ),
      ),
    );
  }
}
