import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: note_content_field.dart
/// ============================================================================
///
/// Reusable content field for creating and editing notes.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays a multiline content input.
/// • Supports validation.
/// • Supports customization.
/// • Contains no business logic.
///
/// ============================================================================

final class NoteContentField extends StatelessWidget {
  const NoteContentField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.validator,
    this.minLines = _defaultMinLines,
    this.maxLines = _defaultMaxLines,
  });

  /// Text controller.
  final TextEditingController controller;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Text changed callback.
  final ValueChanged<String>? onChanged;

  /// Field submitted callback.
  final ValueChanged<String>? onSubmitted;

  /// Enables/disables editing.
  final bool enabled;

  /// Automatically requests focus.
  final bool autofocus;

  /// Read-only mode.
  final bool readOnly;

  /// Custom validator.
  final FormFieldValidator<String>? validator;

  /// Minimum visible lines.
  final int minLines;

  /// Maximum visible lines.
  final int maxLines;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const int _defaultMinLines = 8;
  static const int _defaultMaxLines = 12;

  static const double _iconBottomPadding = 120.0;

  static const EdgeInsets _scrollPadding = EdgeInsets.only(bottom: 120);

  static const InputDecoration _decoration = InputDecoration(
    labelText: 'Content',
    hintText: 'Write your note here...',
    alignLabelWithHint: true,
    prefixIcon: Padding(
      padding: EdgeInsets.only(bottom: _iconBottomPadding),
      child: Icon(Icons.notes_outlined),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Note content',
      textField: true,
      multiline: true,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        autofocus: autofocus,
        readOnly: readOnly,

        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.sentences,

        enableSuggestions: true,
        autocorrect: true,

        minLines: minLines,
        maxLines: maxLines,

        maxLength: NotesConstants.maxContentLength,

        scrollPadding: _scrollPadding,

        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(NotesConstants.maxContentLength),
        ],

        decoration: _decoration,

        validator: validator ?? _defaultValidator,

        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }

  // ===========================================================================
  // Validation
  // ===========================================================================

  static String? _defaultValidator(String? value) {
    final String text = value?.trim() ?? '';

    if (text.length > NotesConstants.maxContentLength) {
      return 'Content cannot exceed '
          '${NotesConstants.maxContentLength} characters.';
    }

    return null;
  }
}
