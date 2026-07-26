import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_popup_menu.dart
/// ============================================================================
///
/// Enterprise Material 3 popup menu.
///
/// Provides a reusable, type-safe popup menu implementation with a consistent
/// look and behavior across the application.
///
/// Typical use cases:
///
/// - Note actions
/// - Overflow menus
/// - Profile menu
/// - Settings menu
/// - Context actions
///
/// The implementation intentionally wraps Flutter's [PopupMenuButton] while
/// exposing a simplified and reusable API.
/// ============================================================================

/// Represents a popup menu item.
@immutable
final class PopupMenuItemData<T> {
  /// Creates a popup menu item.
  const PopupMenuItemData({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.isDestructive = false,
    this.semanticLabel,
  });

  /// Value returned when this item is selected.
  final T value;

  /// Display label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether the item is enabled.
  final bool enabled;

  /// Whether this action represents a destructive operation.
  ///
  /// Example:
  /// - Delete
  /// - Remove
  /// - Sign Out
  final bool isDestructive;

  /// Optional accessibility label.
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
    this.iconSize,
    this.offset = Offset.zero,
    this.padding,
    this.shape,
  });

  /// Popup menu items.
  final List<PopupMenuItemData<T>> items;

  /// Invoked when a menu item is selected.
  final ValueChanged<T> onSelected;

  /// Icon displayed by the popup button.
  final IconData icon;

  /// Optional tooltip.
  final String? tooltip;

  /// Whether the popup menu is enabled.
  final bool enabled;

  /// Optional icon size.
  final double? iconSize;

  /// Popup menu offset.
  final Offset offset;

  /// Optional button padding.
  final EdgeInsetsGeometry? padding;

  /// Optional popup shape.
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: tooltip,
      child: PopupMenuButton<T>(
        enabled: enabled,
        tooltip: tooltip,
        onSelected: onSelected,
        offset: offset,
        padding: padding ?? const EdgeInsets.all(8),
        shape:
            shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        itemBuilder: (_) =>
            List<PopupMenuEntry<T>>.generate(items.length, (index) {
              final item = items[index];

              final color = item.isDestructive ? theme.colorScheme.error : null;

              return PopupMenuItem<T>(
                value: item.value,
                enabled: item.enabled,
                child: Semantics(
                  button: true,
                  enabled: item.enabled,
                  label: item.semanticLabel ?? item.label,
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
                ),
              );
            }),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}
