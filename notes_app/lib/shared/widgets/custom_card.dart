import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_card.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable card.
///
/// Provides a centralized card implementation with consistent styling,
/// interaction behavior, accessibility, and responsive behavior.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Ripple support
/// - Hover support
/// - Keyboard friendly
/// - Lightweight rendering
/// - Reusable across features
///
/// Common usage:
///
/// - Note cards
/// - Profile cards
/// - Settings sections
/// - Dashboard panels
/// - Empty states
/// - Statistics cards
@immutable
final class CustomCard extends StatelessWidget {
  /// Creates a reusable application card.
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.enabled = true,
    this.elevation = 0,
    this.borderRadius = 20,
    this.clipBehavior = Clip.antiAlias,
    this.color,
    this.border,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
  });

  /// Content displayed inside the card.
  final Widget child;

  /// Internal spacing.
  final EdgeInsetsGeometry padding;

  /// External spacing.
  final EdgeInsetsGeometry margin;

  /// Callback invoked when tapped.
  final VoidCallback? onTap;

  /// Whether the card is interactive.
  final bool enabled;

  /// Card elevation.
  final double elevation;

  /// Corner radius.
  final double borderRadius;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Background color.
  final Color? color;

  /// Optional border.
  final BorderSide? border;

  /// Shadow color.
  final Color? shadowColor;

  /// Material 3 surface tint.
  final Color? surfaceTintColor;

  /// Accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(borderRadius);

    final effectiveOnTap = enabled ? onTap : null;

    return Semantics(
      container: true,
      button: effectiveOnTap != null,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: color ?? theme.colorScheme.surfaceContainerLow,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side:
              border ??
              BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
        ),
        clipBehavior: clipBehavior,
        child: InkWell(
          onTap: effectiveOnTap,
          borderRadius: radius,
          mouseCursor: effectiveOnTap != null
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
