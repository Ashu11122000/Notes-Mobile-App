import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: notes_search_bar.dart
/// ============================================================================
///
/// Reusable Notes Search Bar.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Reusable search field.
/// • Debounces user input.
/// • Emits callbacks.
/// • Contains no business logic.
///
/// ============================================================================

final class NotesSearchBar extends StatefulWidget {
  const NotesSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search notes...',
    this.debounce = NotesConstants.searchDebounce,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
  });

  /// External controller.
  final TextEditingController? controller;

  /// Hint text.
  final String hintText;

  /// Debounce duration.
  final Duration debounce;

  /// Called after debounce.
  final ValueChanged<String>? onChanged;

  /// Called on search submit.
  final ValueChanged<String>? onSubmitted;

  /// Called after clearing.
  final VoidCallback? onClear;

  /// Automatically request focus.
  final bool autofocus;

  /// Enables/disables the field.
  final bool enabled;

  /// Read-only mode.
  final bool readOnly;

  @override
  State<NotesSearchBar> createState() => _NotesSearchBarState();
}

final class _NotesSearchBarState extends State<NotesSearchBar> {
  late TextEditingController _controller;

  Timer? _debounce;

  bool _ownsController = false;

  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(covariant NotesSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_updateTextState);

      if (_ownsController) {
        _controller.dispose();
      }

      _initializeController();
    }
  }

  void _initializeController() {
    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
      _ownsController = false;
    }

    _hasText.value = _controller.text.isNotEmpty;

    _controller.addListener(_updateTextState);
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _controller.removeListener(_updateTextState);

    if (_ownsController) {
      _controller.dispose();
    }

    _hasText.dispose();

    super.dispose();
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  void _updateTextState() {
    final bool hasText = _controller.text.isNotEmpty;

    if (_hasText.value == hasText) {
      return;
    }

    _hasText.value = hasText;
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(widget.debounce, () {
      if (!mounted) {
        return;
      }

      widget.onChanged?.call(value.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();

    if (_controller.text.isEmpty) {
      return;
    }

    _controller.clear();

    widget.onClear?.call();

    widget.onChanged?.call('');
  }

  void _submit(String value) {
    _debounce?.cancel();

    widget.onSubmitted?.call(value.trim());
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Search notes',
      child: ValueListenableBuilder<bool>(
        valueListenable: _hasText,
        child: IconButton(
          tooltip: 'Clear search',
          onPressed: _clear,
          icon: const Icon(Icons.close_rounded),
        ),
        builder: (BuildContext context, bool hasText, Widget? clearButton) {
          return SearchBar(
            controller: _controller,

            enabled: widget.enabled,

            readOnly: widget.readOnly,

            autoFocus: widget.autofocus,

            hintText: widget.hintText,

            leading: const Icon(Icons.search_rounded),

            trailing: hasText ? <Widget>[clearButton!] : null,

            textInputAction: TextInputAction.search,

            onChanged: _onChanged,

            onSubmitted: _submit,
          );
        },
      ),
    );
  }
}
