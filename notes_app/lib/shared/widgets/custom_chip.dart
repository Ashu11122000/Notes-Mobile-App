import 'package:flutter/material.dart';

/// A reusable Material 3 filter chip.
///
/// This widget provides a consistent appearance for selectable chips
/// throughout the application.
///
/// Example:
/// ```dart
/// CustomChip(
///   label: 'All',
///   selected: true,
///   onSelected: (_) {},
/// )
/// ```
class CustomChip extends StatelessWidget {
  /// Creates a reusable filter chip.
  const CustomChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
    this.tooltip,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  /// Text displayed inside the chip.
  final String label;

  /// Whether the chip is selected.
  final bool selected;

  /// Called when the selection state changes.
  final ValueChanged<bool> onSelected;

  /// Optional leading widget.
  final Widget? avatar;

  /// Optional tooltip.
  final String? tooltip;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    Widget chip = FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      avatar: avatar,
      padding: padding,
      showCheckmark: false,
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      chip = Tooltip(message: tooltip!, child: chip);
    }

    return chip;
  }
}
