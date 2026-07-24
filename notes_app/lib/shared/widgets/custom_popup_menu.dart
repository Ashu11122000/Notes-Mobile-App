import 'package:flutter/material.dart';

/// Represents a popup menu item.
///
/// This model is shared by [CustomPopupMenu] and encapsulates the
/// information required to render a menu option.
@immutable
class PopupMenuItemData<T> {
  /// Creates a popup menu item.
  const PopupMenuItemData({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// Value returned when the item is selected.
  final T value;

  /// Text displayed for the menu item.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether the item is enabled.
  final bool enabled;
}

/// A reusable Material 3 popup menu.
///
/// This widget provides a consistent popup menu implementation while
/// remaining generic enough for use across the application.
///
/// Example:
/// ```dart
/// CustomPopupMenu<String>(
///   items: [
///     PopupMenuItemData(
///       value: 'edit',
///       label: 'Edit',
///       icon: Icons.edit_rounded,
///     ),
///     PopupMenuItemData(
///       value: 'delete',
///       label: 'Delete',
///       icon: Icons.delete_rounded,
///     ),
///   ],
///   onSelected: (value) {},
/// )
/// ```
class CustomPopupMenu<T> extends StatelessWidget {
  /// Creates a reusable popup menu.
  const CustomPopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_vert_rounded,
    this.tooltip,
    this.enabled = true,
  });

  /// Menu items.
  final List<PopupMenuItemData<T>> items;

  /// Called when a menu item is selected.
  final ValueChanged<T> onSelected;

  /// Icon displayed for the popup button.
  final IconData icon;

  /// Optional tooltip.
  final String? tooltip;

  /// Whether the popup menu is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      enabled: enabled,
      tooltip: tooltip,
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(child: Text(item.label)),
              ],
            ),
          );
        }).toList();
      },
      icon: Icon(icon),
    );
  }
}
