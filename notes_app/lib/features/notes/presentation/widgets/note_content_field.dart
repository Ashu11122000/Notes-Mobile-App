import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: note_content_field.dart
/// ============================================================================
///
/// Note Content Field
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Reusable content input field for Notes.
/// - Used by both Create Note and Edit Note screens.
/// - Contains no business logic.
/// - Supports validation and customization.
///
/// ============================================================================
class NoteContentField extends StatelessWidget {
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
    this.minLines = 8,
    this.maxLines = 12,
  });

  /// Controller for the content field.
  final TextEditingController controller;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Called whenever the value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onSubmitted;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field should autofocus.
  final bool autofocus;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Optional custom validator.
  final FormFieldValidator<String>? validator;

  /// Minimum number of visible lines.
  final int minLines;

  /// Maximum number of visible lines.
  final int maxLines;

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
      minLines: minLines,
      maxLines: maxLines,
      maxLength: NotesConstants.maxContentLength,
      decoration: const InputDecoration(
        labelText: 'Content',
        hintText: 'Write your note here...',
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 120),
          child: Icon(Icons.notes_outlined),
        ),
      ),
      validator:
          validator ??
          (value) {
            final text = value?.trim();

            if (text != null && text.length > NotesConstants.maxContentLength) {
              return 'Content cannot exceed '
                  '${NotesConstants.maxContentLength} characters.';
            }

            return null;
          },
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}
