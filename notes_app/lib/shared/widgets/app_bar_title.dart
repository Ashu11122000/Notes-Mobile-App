import 'package:flutter/material.dart';

/// =============================================================================
/// File: app_bar_title.dart
/// =============================================================================
///
/// A reusable Material 3 app bar title.
///
/// Provides a consistent, accessible, and theme-aware title for application
/// app bars.
///
/// Features:
/// - Material 3 typography
/// - Theme-aware styling
/// - Accessibility support
/// - Optional tooltip
/// - Lightweight implementation
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

  /// Title text.
  final String title;

  /// Text alignment.
  final TextAlign textAlign;

  /// Maximum number of lines.
  final int maxLines;

  /// Overflow behavior.
  final TextOverflow overflow;

  /// Optional text style.
  final TextStyle? style;

  /// Optional tooltip.
  ///
  /// When null, no tooltip is shown.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: false,
      overflow: overflow,
      style: style ?? theme.textTheme.titleLarge,
    );

    return Semantics(
      header: true,
      child: tooltip == null
          ? text
          : Tooltip(
              message: tooltip!,
              waitDuration: const Duration(milliseconds: 500),
              child: text,
            ),
    );
  }
}
