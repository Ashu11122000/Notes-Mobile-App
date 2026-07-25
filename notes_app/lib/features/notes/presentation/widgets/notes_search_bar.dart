import 'dart:async';

import 'package:flutter/material.dart';

/// ============================================================================
/// File: notes_search_bar.dart
/// ============================================================================
///
/// Notes Search Bar
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Provides a reusable search input for the Notes feature.
/// - Debounces user input to reduce unnecessary search operations.
/// - Contains no business logic.
/// - Supports local or remote search through callbacks.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesSearchBar
///     ↓
/// Callback
///     ↓
/// Provider / Screen
///
/// ============================================================================

class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search notes...',
    this.debounce = const Duration(milliseconds: 400),
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Placeholder text.
  final String hintText;

  /// Debounce duration.
  final Duration debounce;

  /// Called after the debounce duration.
  final ValueChanged<String>? onChanged;

  /// Called when the keyboard search action is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Called when the search field is cleared.
  final VoidCallback? onClear;

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

class _NotesSearchBarState extends State<NotesSearchBar> {
  late final TextEditingController _controller;

  Timer? _debounce;

  bool _ownsController = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      widget.debounce,
      () => widget.onChanged?.call(value.trim()),
    );

    setState(() {});
  }

  void _clear() {
    _debounce?.cancel();

    _controller.clear();

    widget.onClear?.call();

    widget.onChanged?.call('');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      hintText: widget.hintText,
      leading: const Icon(Icons.search),
      trailing: [
        if (_controller.text.isNotEmpty)
          IconButton(
            tooltip: 'Clear',
            onPressed: _clear,
            icon: const Icon(Icons.close),
          ),
      ],
      textInputAction: TextInputAction.search,
      onChanged: _onTextChanged,
      onSubmitted: (value) => widget.onSubmitted?.call(value.trim()),
    );
  }
}
