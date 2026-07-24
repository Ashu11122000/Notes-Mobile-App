import 'package:flutter/material.dart';

/// A reusable title widget for Material 3 app bars.
///
/// This widget provides a consistent appearance for app bar titles
/// throughout the application while inheriting typography from the
/// active theme.
///
/// Example:
/// ```dart
/// AppBar(
///   title: const AppBarTitle('Login'),
/// )
/// ```
class AppBarTitle extends StatelessWidget {
  /// Creates an app bar title.
  const AppBarTitle(
    this.title, {
    super.key,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  /// Title text displayed in the app bar.
  final String title;

  /// Alignment of the title text.
  final TextAlign textAlign;

  /// Maximum number of lines.
  final int maxLines;

  /// Overflow behavior.
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
