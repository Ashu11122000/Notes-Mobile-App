import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_popup_menu.dart
/// ============================================================================
///
/// Enterprise Material 3 popup menu.
///
/// Provides a reusable, type-safe popup menu implementation with consistent
/// styling and behavior across the application.
///
/// Common usage:
///
/// - Note actions
/// - Overflow menus
/// - Profile menu
/// - Settings menu
/// - Context actions
@immutable
final class PopupMenuItemData<T> {
  /// Creates popup menu item data.
  const PopupMenuItemData({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.isDestructive = false,
    this.semanticLabel,
  });

  /// Returned value when selected.
  final T value;

  /// Display label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether item is enabled.
  final bool enabled;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Accessibility label.
  final String? semanticLabel;
}

/// Enterprise Material 3 popup menu.
@immutable
final class CustomPopupMenu<T> extends StatelessWidget {
  /// Creates a reusable popup menu.
  const CustomPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_vert_rounded,
    this.tooltip,
    this.enabled = true,
    this.iconSize = 24,
    this.offset = Offset.zero,
    this.padding = const EdgeInsets.all(8),
    this.shape,
    this.iconColor,
  });

  /// Menu items.
  final List<PopupMenuItemData<T>> items;

  /// Selection callback.
  final ValueChanged<T> onSelected;

  /// Trigger icon.
  final IconData icon;

  /// Tooltip.
  final String? tooltip;

  /// Enable/disable menu.
  final bool enabled;

  /// Icon size.
  final double iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Popup offset.
  final Offset offset;

  /// Button padding.
  final EdgeInsetsGeometry padding;

  /// Popup shape.
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<T>(
      enabled: enabled,
      tooltip: tooltip,
      onSelected: onSelected,
      offset: offset,
      padding: padding,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) {
        return items
            .map((item) {
              final color = item.isDestructive ? theme.colorScheme.error : null;

              return PopupMenuItem<T>(
                value: item.value,
                enabled: item.enabled,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 20, color: color),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: color != null ? TextStyle(color: color) : null,
                      ),
                    ),
                  ],
                ),
              );
            })
            .toList(growable: false);
      },
      icon: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
