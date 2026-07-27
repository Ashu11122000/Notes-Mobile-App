import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: note_content_field.dart
/// ============================================================================
///
/// Note Content Field.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Reusable note content input.
/// • Used by create and edit note screens.
/// • Handles only presentation logic.
/// • Supports validation and customization.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// NoteContentField
///  ↓
/// Form Controller
///  ↓
/// NotesProvider
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

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Enables/disables field.
  final bool enabled;

  /// Automatically focuses field.
  final bool autofocus;

  /// Makes field read-only.
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

  static const double _iconBottomPadding = 120;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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

      scrollPadding: const EdgeInsets.only(bottom: 120),

      decoration: const InputDecoration(
        labelText: 'Content',

        hintText: 'Write your note here...',

        alignLabelWithHint: true,

        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: _iconBottomPadding),

          child: Icon(Icons.notes_outlined),
        ),
      ),

      validator: validator ?? _defaultValidator,

      onChanged: onChanged,

      onFieldSubmitted: onSubmitted,
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
