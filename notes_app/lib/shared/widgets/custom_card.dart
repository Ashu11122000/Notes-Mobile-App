import 'package:flutter/material.dart';

/// A reusable Material 3 card used throughout the application.
///
/// This widget provides a consistent card appearance while allowing
/// customization of padding, margin, border radius, elevation,
/// and tap behavior.
///
/// Example:
/// ```dart
/// CustomCard(
///   child: Text('Hello'),
/// )
/// ```
class CustomCard extends StatelessWidget {
  /// Creates a reusable application card.
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.elevation = 0,
    this.borderRadius = 16,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Widget displayed inside the card.
  final Widget child;

  /// Internal spacing.
  final EdgeInsetsGeometry padding;

  /// External spacing.
  final EdgeInsetsGeometry margin;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Card elevation.
  final double elevation;

  /// Corner radius.
  final double borderRadius;

  /// Clip behavior.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      margin: margin,
      clipBehavior: clipBehavior,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: card,
    );
  }
}
