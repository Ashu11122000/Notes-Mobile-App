import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_search_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 search bar.
///
/// A reusable wrapper around Flutter's Material 3 [SearchBar] that provides
/// a consistent search experience throughout the application.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Responsive
/// - Accessible
/// - Keyboard friendly
/// - Desktop/Web friendly
/// - Lightweight
///
/// Typical use cases:
///
/// - Notes search
/// - User search
/// - Filter bars
/// - Dashboard search
/// - Global search
///
/// Example:
///
/// ```dart
/// CustomSearchBar(
///   controller: controller,
///   hintText: 'Search notes...',
///   onChanged: provider.search,
/// )
/// ```
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
    this.enabled = true,
    this.autoFocus = false,
    this.semanticLabel,
    this.textInputAction = TextInputAction.search,
    this.textCapitalization = TextCapitalization.none,
    this.constraints,
    this.showClearButton = true,
  });

  /// Controller for the search field.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Placeholder text.
  final String hintText;

  /// Leading widget.
  ///
  /// Defaults to a search icon.
  final Widget? leading;

  /// Optional trailing widgets.
  final List<Widget>? trailing;

  /// Invoked whenever the search text changes.
  final ValueChanged<String>? onChanged;

  /// Invoked when the user submits the search.
  final ValueChanged<String>? onSubmitted;

  /// Invoked when the search bar is tapped.
  final VoidCallback? onTap;

  /// Whether the search bar is enabled.
  final bool enabled;

  /// Whether the search field should receive focus automatically.
  final bool autoFocus;

  /// Optional accessibility label.
  final String? semanticLabel;

  /// Keyboard action button.
  final TextInputAction textInputAction;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Optional layout constraints.
  final BoxConstraints? constraints;

  /// Whether a clear button should automatically appear when text exists.
  final bool showClearButton;

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
        ),
      ),
    );
  }
}
