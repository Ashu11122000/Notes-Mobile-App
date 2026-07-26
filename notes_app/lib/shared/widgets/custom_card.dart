import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_card.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable card.
///
/// This widget provides a centralized implementation of cards used throughout
/// the application, ensuring a consistent appearance, interaction model, and
/// accessibility.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Keyboard friendly
/// - Hover support
/// - Proper ripple effects
/// - Responsive
/// - Lightweight
///
/// Typical use cases:
///
/// - Note cards
/// - Profile cards
/// - Settings sections
/// - Dashboard panels
/// - Empty states
/// - Statistics cards
///
/// Example:
///
/// ```dart
/// CustomCard(
///   onTap: () {},
///   child: Text('Hello'),
/// )
/// ```
@immutable
final class CustomCard extends StatelessWidget {
  /// Creates a reusable application card.
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.elevation = 0,
    this.borderRadius = 20,
    this.clipBehavior = Clip.antiAlias,
    this.color,
    this.border,
    this.shadowColor,
    this.semanticLabel,
  });

  /// Content displayed inside the card.
  final Widget child;

  /// Internal spacing.
  final EdgeInsetsGeometry padding;

  /// External spacing.
  final EdgeInsetsGeometry margin;

  /// Callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Card elevation.
  final double elevation;

  /// Card corner radius.
  final double borderRadius;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Optional background color.
  final Color? color;

  /// Optional border.
  final BorderSide? border;

  /// Optional shadow color.
  final Color? shadowColor;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(borderRadius);

    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: Card(
        margin: margin,
        elevation: elevation,
        clipBehavior: clipBehavior,
        color: color,
        shadowColor: shadowColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border != null
              ? BorderSide(color: border!.color, width: border!.width)
              : BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          mouseCursor: onTap != null
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
