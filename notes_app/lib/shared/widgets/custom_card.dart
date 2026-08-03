import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_card.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable card.
///
/// Provides a consistent card surface across the application.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme aware
/// - Accessible
/// - Ripple support
/// - Lightweight
/// - Reusable
///
/// Used for:
///
/// - Notes
/// - Dashboard panels
/// - Settings sections
/// - Empty states
/// - Profile cards
@immutable
final class CustomCard extends StatelessWidget {
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

  /// Card content.
  final Widget child;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin.
  final EdgeInsetsGeometry margin;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Enables interaction.
  final bool enabled;

  /// Elevation.
  final double elevation;

  /// Corner radius.
  final double borderRadius;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Background color.
  final Color? color;

  /// Border.
  final BorderSide? border;

  /// Shadow color.
  final Color? shadowColor;

  /// Surface tint.
  final Color? surfaceTintColor;

  /// Accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(borderRadius);

    final effectiveOnTap = enabled ? onTap : null;

    final shape = RoundedRectangleBorder(
      borderRadius: radius,

      side:
          border ??
          BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
    );

    Widget content = Padding(padding: padding, child: child);

    if (effectiveOnTap != null) {
      content = InkWell(
        onTap: effectiveOnTap,

        borderRadius: radius,

        mouseCursor: SystemMouseCursors.click,

        child: content,
      );
    }

    return Semantics(
      container: true,

      button: effectiveOnTap != null,

      enabled: effectiveOnTap != null,

      label: semanticLabel,

      child: Material(
        color: color ?? theme.colorScheme.surfaceContainerLow,

        elevation: elevation,

        shadowColor: shadowColor,

        surfaceTintColor: surfaceTintColor,

        shape: shape,

        clipBehavior: clipBehavior,

        child: content,
      ),
    );
  }
}
