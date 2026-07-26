import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_chip.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable filter chip.
///
/// This widget standardizes the appearance and behavior of selectable chips
/// throughout the application while remaining lightweight and highly
/// customizable.
///
/// Features:
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Tooltip support
/// - Desktop/Web friendly
/// - Reusable across features
///
/// Typical use cases:
/// - Note filters
/// - Categories
/// - Tags
/// - Search suggestions
/// - Sort options
/// - Settings
///
/// Example:
///
/// ```dart
/// CustomChip(
///   label: 'All',
///   selected: true,
///   onSelected: (_) {},
/// )
/// ```
@immutable
final class CustomChip extends StatelessWidget {
  /// Creates a reusable Material 3 filter chip.
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
    this.tooltip,
    this.semanticLabel,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.visualDensity = VisualDensity.compact,
    this.elevation = 0,
    this.selectedColor,
    this.backgroundColor,
  });

  /// Text displayed inside the chip.
  final String label;

  /// Whether the chip is currently selected.
  final bool selected;

  /// Invoked when the chip selection changes.
  final ValueChanged<bool> onSelected;

  /// Optional leading widget.
  final Widget? avatar;

  /// Optional tooltip shown on long press or hover.
  final String? tooltip;

  /// Optional accessibility label.
  final String? semanticLabel;

  /// Optional label text style.
  final TextStyle? labelStyle;

  /// Internal chip padding.
  final EdgeInsetsGeometry padding;

  /// Visual density of the chip.
  final VisualDensity visualDensity;

  /// Chip elevation.
  final double elevation;

  /// Optional selected background color.
  final Color? selectedColor;

  /// Optional unselected background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget chip = Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      child: FilterChip(
        label: Text(label, style: labelStyle),
        selected: selected,
        onSelected: onSelected,
        avatar: avatar,
        padding: padding,
        elevation: elevation,
        showCheckmark: false,
        visualDensity: visualDensity,
        mouseCursor: SystemMouseCursors.click,
        backgroundColor:
            backgroundColor ?? theme.colorScheme.surfaceContainerLow,
        selectedColor: selectedColor ?? theme.colorScheme.secondaryContainer,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
