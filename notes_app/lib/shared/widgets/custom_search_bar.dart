import 'package:flutter/material.dart';

/// A reusable Material 3 search bar.
///
/// This widget wraps Flutter's Material 3 [SearchBar] to provide a
/// consistent search experience throughout the application.
///
/// Example:
/// ```dart
/// CustomSearchBar(
///   controller: controller,
///   hintText: 'Search notes...',
///   onChanged: provider.search,
/// )
/// ```
class CustomSearchBar extends StatelessWidget {
  /// Creates a reusable search bar.
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

  /// Trailing widgets.
  final List<Widget>? trailing;

  /// Called whenever the search text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the search.
  final ValueChanged<String>? onSubmitted;

  /// Called when the search bar is tapped.
  final VoidCallback? onTap;

  /// Whether the search bar is enabled.
  final bool enabled;

  /// Whether the search bar should receive focus automatically.
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      leading: leading ?? const Icon(Icons.search_rounded),
      trailing: trailing,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      enabled: enabled,
      autoFocus: autoFocus,
    );
  }
}
