import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: note_title_field.dart
/// ============================================================================
///
/// Note Title Field
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Reusable title input for Notes forms.
/// - Used by Create Note and Edit Note screens.
/// - Contains no business logic.
/// - Supports validation and customization.
///
/// ============================================================================
class NoteTitleField extends StatelessWidget {
  const NoteTitleField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.textInputAction = TextInputAction.next,
    this.validator,
  });

  /// Controller for the title field.
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

  /// Keyboard action.
  final TextInputAction textInputAction;

  /// Optional custom validator.
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      readOnly: readOnly,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      maxLength: NotesConstants.maxTitleLength,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter note title',
        prefixIcon: Icon(Icons.title),
      ),
      validator:
          validator ??
          (value) {
            final text = value?.trim() ?? '';

            if (text.isEmpty) {
              return 'Title is required.';
            }

            if (text.length < NotesConstants.minTitleLength) {
              return 'Title is too short.';
            }

            if (text.length > NotesConstants.maxTitleLength) {
              return 'Title cannot exceed '
                  '${NotesConstants.maxTitleLength} characters.';
            }

            return null;
          },
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
    );
  }
}
