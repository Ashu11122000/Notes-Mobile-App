import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_chip.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable filter chip.
///
/// Standardizes selectable chips across the application while remaining
/// lightweight, accessible, and customizable.
///
/// Common usage:
///
/// - Note filters
/// - Categories
/// - Tags
/// - Search suggestions
/// - Sort options
/// - Settings
@immutable
final class CustomChip extends StatelessWidget {
  /// Creates a reusable Material 3 filter chip.
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    this.avatar,
    this.onDeleted,
    this.tooltip,
    this.semanticLabel,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.visualDensity = VisualDensity.compact,
    this.elevation = 0,
    this.selectedColor,
    this.backgroundColor,
    this.shape,
  });

  /// Text displayed inside the chip.
  final String label;

  /// Whether the chip is selected.
  final bool selected;

  /// Whether the chip is enabled.
  final bool enabled;

  /// Called when selection changes.
  final ValueChanged<bool> onSelected;

  /// Optional leading widget.
  final Widget? avatar;

  /// Optional delete callback.
  ///
  /// Useful for removable tags.
  final VoidCallback? onDeleted;

  /// Tooltip displayed on hover/long press.
  final String? tooltip;

  /// Accessibility label.
  final String? semanticLabel;

  /// Optional label style.
  final TextStyle? labelStyle;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Visual density.
  final VisualDensity visualDensity;

  /// Chip elevation.
  final double elevation;

  /// Selected background color.
  final Color? selectedColor;

  /// Unselected background color.
  final Color? backgroundColor;

  /// Custom chip shape.
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isEnabled = enabled;

    Widget chip = Semantics(
      button: true,
      enabled: isEnabled,
      selected: selected,
      label: semanticLabel ?? label,
      child: FilterChip(
        label: Text(label, style: labelStyle),
        selected: selected,
        onSelected: isEnabled ? onSelected : null,
        onDeleted: onDeleted,
        avatar: avatar,
        padding: padding,
        elevation: elevation,
        showCheckmark: false,
        visualDensity: visualDensity,
        mouseCursor: isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        backgroundColor:
            backgroundColor ?? theme.colorScheme.surfaceContainerLow,
        selectedColor: selectedColor ?? theme.colorScheme.secondaryContainer,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final hasTooltip = tooltip != null && tooltip!.trim().isNotEmpty;

    if (hasTooltip) {
      chip = Tooltip(
        message: tooltip!,
        waitDuration: const Duration(milliseconds: 500),
        child: chip,
      );
    }

    return chip;
  }
}
