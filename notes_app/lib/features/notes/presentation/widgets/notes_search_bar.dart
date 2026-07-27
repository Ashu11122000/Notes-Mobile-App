import 'dart:async';

import 'package:flutter/material.dart';

/// ============================================================================
/// File: notes_search_bar.dart
/// ============================================================================
///
/// Notes Search Bar.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Provides reusable Notes search input.
/// • Debounces user input.
/// • Emits search callbacks.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// NotesSearchBar
///  ↓
/// Callback
///  ↓
/// Provider / Screen
///
/// ============================================================================

final class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search notes...',
    this.debounce = const Duration(milliseconds: 400),
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
  });

  /// External controller.
  final TextEditingController? controller;

  /// Search hint.
  final String hintText;

  /// Debounce duration.
  final Duration debounce;

  /// Called after debounce.
  final ValueChanged<String>? onChanged;

  /// Called when search submitted.
  final ValueChanged<String>? onSubmitted;

  /// Called when cleared.
  final VoidCallback? onClear;

  /// Autofocus search.
  final bool autofocus;

  /// Enables field.
  final bool enabled;

  /// Read-only state.
  final bool readOnly;

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

final class _NotesSearchBarState extends State<NotesSearchBar> {
  late final TextEditingController _controller;

  Timer? _debounce;

  bool _ownsController = false;

  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();

      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }

    _hasText.value = _controller.text.isNotEmpty;

    _controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _controller.removeListener(_updateTextState);

    _hasText.dispose();

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  // ===========================================================================
  // Search Handling
  // ===========================================================================

  void _updateTextState() {
    _hasText.value = _controller.text.isNotEmpty;
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(widget.debounce, () {
      widget.onChanged?.call(value.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();

    _controller.clear();

    widget.onClear?.call();

    widget.onChanged?.call('');
  }

  void _submit(String value) {
    widget.onSubmitted?.call(value.trim());
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Search notes',

      child: ValueListenableBuilder<bool>(
        valueListenable: _hasText,

        builder: (BuildContext context, bool hasText, Widget? child) {
          return SearchBar(
            controller: _controller,

            enabled: widget.enabled,

            readOnly: widget.readOnly,

            autoFocus: widget.autofocus,

            hintText: widget.hintText,

            leading: const Icon(Icons.search_rounded),

            trailing: hasText
                ? <Widget>[
                    IconButton(
                      tooltip: 'Clear search',

                      onPressed: _clear,

                      icon: const Icon(Icons.close_rounded),
                    ),
                  ]
                : null,

            textInputAction: TextInputAction.search,

            onChanged: _onTextChanged,

            onSubmitted: _submit,
          );
        },
      ),
    );
  }
}
