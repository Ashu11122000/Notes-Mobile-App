import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_chip.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable filter chip.
///
/// Standardizes selectable chips across the application while remaining:
///
/// - Lightweight
/// - Accessible
/// - Theme aware
/// - Performance optimized
///
/// Common usage:
///
/// - Note filters
/// - Categories
/// - Tags
/// - Search suggestions
/// - Sort options
/// - Settings
/// ============================================================================

@immutable
final class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.tooltip,
    this.semanticLabel,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.visualDensity = VisualDensity.compact,
    this.elevation = 0,
    this.selectedColor,
    this.backgroundColor,
    this.disabledColor,
    this.shape,
    this.mouseCursor,
  });

  /// Chip text.
  final String label;

  /// Whether chip is selected.
  final bool selected;

  /// Whether chip interaction is enabled.
  final bool enabled;

  /// Selection callback.
  final ValueChanged<bool> onSelected;

  /// Leading widget.
  final Widget? avatar;

  /// Delete icon.
  final Widget? deleteIcon;

  /// Delete callback.
  ///
  /// Useful for removable tags.
  final VoidCallback? onDeleted;

  /// Tooltip text.
  final String? tooltip;

  /// Accessibility label.
  final String? semanticLabel;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Visual density.
  final VisualDensity visualDensity;

  /// Chip elevation.
  final double elevation;

  /// Selected background color.
  final Color? selectedColor;

  /// Default background color.
  final Color? backgroundColor;

  /// Disabled background color.
  final Color? disabledColor;

  /// Custom shape.
  final OutlinedBorder? shape;

  /// Mouse cursor.
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chipEnabled = enabled;

    Widget chip = FilterChip(
      label: Text(label, style: labelStyle),

      selected: selected,

      onSelected: chipEnabled ? onSelected : null,

      onDeleted: chipEnabled ? onDeleted : null,

      deleteIcon: deleteIcon,

      avatar: avatar,

      padding: padding,

      elevation: elevation,

      showCheckmark: false,

      visualDensity: visualDensity,

      mouseCursor:
          mouseCursor ??
          (chipEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic),

      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerLow,

      selectedColor: selectedColor ?? theme.colorScheme.secondaryContainer,

      disabledColor: disabledColor ?? theme.colorScheme.surfaceContainerHighest,

      side: BorderSide(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
      ),

      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    chip = Semantics(
      container: true,

      enabled: chipEnabled,

      selected: selected,

      button: chipEnabled,

      label: semanticLabel ?? label,

      child: chip,
    );

    if (tooltip != null && tooltip!.trim().isNotEmpty) {
      chip = Tooltip(
        message: tooltip!,

        waitDuration: const Duration(milliseconds: 500),

        child: chip,
      );
    }

    return chip;
  }
}
