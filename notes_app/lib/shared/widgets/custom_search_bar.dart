import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_search_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 search bar.
///
/// Reusable wrapper around Flutter Material 3 [SearchBar].
///
/// Designed for:
///
/// - Notes search
/// - Global search
/// - Filters
/// - Dashboard search
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Keyboard friendly
/// - Lightweight
/// - Performance optimized
@immutable
final class CustomSearchBar extends StatelessWidget {
  /// Creates a reusable Material 3 search bar.
  const CustomSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Search...',
    this.leading,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.enabled = true,
    this.autoFocus = false,
    this.semanticLabel,
    this.textInputAction = TextInputAction.search,
    this.textCapitalization = TextCapitalization.none,
    this.constraints,
    this.showClearButton = true,
    this.backgroundColor,
    this.elevation,
  });

  /// Text controller.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Hint text.
  final String hintText;

  /// Leading widget.
  final Widget? leading;

  /// Custom trailing widgets.
  final List<Widget>? trailing;

  /// Text change callback.
  final ValueChanged<String>? onChanged;

  /// Submit callback.
  final ValueChanged<String>? onSubmitted;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Clear callback.
  final VoidCallback? onClear;

  /// Whether search is enabled.
  final bool enabled;

  /// Auto focus.
  final bool autoFocus;

  /// Accessibility label.
  final String? semanticLabel;

  /// Keyboard action.
  final TextInputAction textInputAction;

  /// Capitalization.
  final TextCapitalization textCapitalization;

  /// Layout constraints.
  final BoxConstraints? constraints;

  /// Show clear button.
  final bool showClearButton;

  /// Search background color.
  final Color? backgroundColor;

  /// Search elevation.
  final WidgetStateProperty<double?>? elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveTrailing = <Widget>[
      if (trailing != null) ...trailing!,

      if (showClearButton && controller != null)
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller!,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              tooltip: 'Clear search',
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                controller!.clear();

                onChanged?.call('');

                onClear?.call();
              },
            );
          },
        ),
    ];

    return Semantics(
      textField: true,
      label: semanticLabel ?? hintText,
      child: ConstrainedBox(
        constraints: constraints ?? const BoxConstraints(minHeight: 56),
        child: SearchBar(
          controller: controller,
          focusNode: focusNode,
          hintText: hintText,
          leading: leading ?? const Icon(Icons.search_rounded),
          trailing: effectiveTrailing.isEmpty ? null : effectiveTrailing,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          enabled: enabled,
          autoFocus: autoFocus,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          backgroundColor: backgroundColor != null
              ? WidgetStatePropertyAll(backgroundColor)
              : null,
          elevation: elevation,
        ),
      ),
    );
  }
}
