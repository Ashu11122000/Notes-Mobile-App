import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';
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
/// - Supports image attachment.
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

  /// Submit button label.
  final String submitLabel;

  /// Indicates whether the form is submitting.
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
    final FormState? form = _formKey.currentState;

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
    final NotesProvider provider = context.watch<NotesProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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

          const SizedBox(height: 20),

          //--------------------------------------------------------------------
          // Image Attachment
          //--------------------------------------------------------------------
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Attachment',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  //----------------------------------------------------------------
                  // Attach Image Button
                  //----------------------------------------------------------------
                  OutlinedButton.icon(
                    onPressed: widget.isLoading
                        ? null
                        : provider.pickImageFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Attach Image'),
                  ),

                  //----------------------------------------------------------------
                  // Image Preview
                  //----------------------------------------------------------------
                  if (provider.hasSelectedImage) ...[
                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        provider.selectedImage!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      provider.selectedImagePath ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonalIcon(
                        onPressed: widget.isLoading
                            ? null
                            : provider.removeSelectedImage,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remove Image'),
                      ),
                    ),
                  ],
                ],
              ),
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

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
