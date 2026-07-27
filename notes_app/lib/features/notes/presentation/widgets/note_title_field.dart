import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: note_title_field.dart
/// ============================================================================
///
/// Note Title Field.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Reusable title input for Notes forms.
/// • Used by Create Note and Edit Note screens.
/// • Handles only presentation validation.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Screen
///    ↓
/// NoteTitleField
///    ↓
/// Form Controller
///    ↓
/// NotesProvider
///
/// ============================================================================

final class NoteTitleField extends StatelessWidget {
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

  /// Controller for title input.
  final TextEditingController controller;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when submitted.
  final ValueChanged<String>? onSubmitted;

  /// Enables/disables input.
  final bool enabled;

  /// Automatically focuses field.
  final bool autofocus;

  /// Read-only mode.
  final bool readOnly;

  /// Keyboard action.
  final TextInputAction textInputAction;

  /// Custom validator.
  final FormFieldValidator<String>? validator;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const String _label = 'Title';

  static const String _hint = 'Enter note title';

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Note title input',

      child: TextFormField(
        controller: controller,

        focusNode: focusNode,

        enabled: enabled,

        autofocus: autofocus,

        readOnly: readOnly,

        textInputAction: textInputAction,

        keyboardType: TextInputType.text,

        textCapitalization: TextCapitalization.sentences,

        autocorrect: true,

        enableSuggestions: true,

        maxLength: NotesConstants.maxTitleLength,

        decoration: const InputDecoration(
          labelText: _label,

          hintText: _hint,

          prefixIcon: Icon(Icons.title_rounded),
        ),

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
  }
}
