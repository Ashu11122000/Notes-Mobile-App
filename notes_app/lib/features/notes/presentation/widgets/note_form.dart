import 'package:flutter/material.dart';

import 'note_content_field.dart';
import 'note_title_field.dart';

/// ============================================================================
/// File: note_form.dart
/// ============================================================================
///
/// Reusable Note Form.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Shared form for creating and editing notes.
/// - Handles validation.
/// - Exposes submitted values through callbacks.
/// - Contains no business logic.
/// - Reuses NoteTitleField and NoteContentField.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// CreateNoteScreen
///         │
/// EditNoteScreen
///         │
///         ▼
///      NoteForm
///
/// ============================================================================

class NoteForm extends StatefulWidget {
  const NoteForm({
    super.key,
    this.initialTitle = '',
    this.initialContent = '',
    this.submitLabel = 'Save',
    this.isLoading = false,
    required this.onSubmit,
  });

  /// Initial title value.
  final String initialTitle;

  /// Initial content value.
  final String initialContent;

  /// Button label.
  final String submitLabel;

  /// Indicates whether the form is currently submitting.
  final bool isLoading;

  /// Called after successful validation.
  final Future<void> Function(String title, String? content) onSubmit;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.initialTitle);

    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    _titleFocusNode.dispose();
    _contentFocusNode.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    await widget.onSubmit(
      _titleController.text.trim(),
      _contentController.text.trim().isEmpty
          ? null
          : _contentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //--------------------------------------------------------------------
          // Title
          //--------------------------------------------------------------------
          NoteTitleField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            enabled: !widget.isLoading,
            onSubmitted: (_) {
              _contentFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          //--------------------------------------------------------------------
          // Content
          //--------------------------------------------------------------------
          Expanded(
            child: NoteContentField(
              controller: _contentController,
              focusNode: _contentFocusNode,
              enabled: !widget.isLoading,
            ),
          ),

          const SizedBox(height: 24),

          //--------------------------------------------------------------------
          // Submit Button
          //--------------------------------------------------------------------
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.isLoading ? null : _submit,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(widget.submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}
