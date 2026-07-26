import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifications/models/reminder_model.dart';
import '../../../notifications/utils/reminder_manager.dart';
import '../providers/notes_provider.dart';
import 'note_content_field.dart';
import 'note_title_field.dart';

/// ============================================================================
/// File: note_form.dart
/// ============================================================================
///
/// Reusable Note Form
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Shared form for creating and editing notes.
/// • Handles validation.
/// • Supports image attachment.
/// • Supports local reminders.
/// • Produces a ReminderModel.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Add/Edit Screen
///         │
///         ▼
///     NoteForm
///         │
///         ▼
///   onSubmit(...)
///
/// ============================================================================

final class NoteForm extends StatefulWidget {
  const NoteForm({
    super.key,
    this.initialTitle = '',
    this.initialContent = '',
    this.submitLabel = 'Save',
    this.isLoading = false,
    required this.onSubmit,
  });

  final String initialTitle;

  final String initialContent;

  final String submitLabel;

  final bool isLoading;

  final Future<void> Function(
    String title,
    String? content,
    ReminderModel? reminder,
  )
  onSubmit;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

final class _NoteFormState extends State<NoteForm> {
  // ===========================================================================
  // Form
  // ===========================================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;

  late final TextEditingController _contentController;

  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _contentFocusNode = FocusNode();

  // ===========================================================================
  // Reminder State
  // ===========================================================================

  bool _reminderEnabled = false;

  DateTime? _selectedDate;

  TimeOfDay? _selectedTime;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

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

  // ===========================================================================
  // Reminder Helpers
  // ===========================================================================

  Future<void> _pickReminderDate() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      initialDate: _selectedDate ?? now,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _clearReminder() {
    setState(() {
      _reminderEnabled = false;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  DateTime? _buildReminderDateTime() {
    if (_selectedDate == null || _selectedTime == null) {
      return null;
    }

    final DateTime scheduledAt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (scheduledAt.isBefore(DateTime.now())) {
      return null;
    }

    return scheduledAt;
  }

  bool get _hasValidReminder =>
      _reminderEnabled && _buildReminderDateTime() != null;

  // ===========================================================================
  // Submit
  // ===========================================================================

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    ReminderModel? reminder;

    if (_reminderEnabled) {
      final DateTime? scheduledAt = _buildReminderDateTime();

      if (scheduledAt == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select a valid future date and time for the reminder.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }

      reminder = ReminderModel(
        notificationId: await ReminderManager.instance.nextNotificationId(),
        noteId: 0,
        title: _titleController.text.trim(),
        body: _contentController.text.trim().isEmpty
            ? 'Reminder for your note'
            : _contentController.text.trim(),
        scheduledAt: scheduledAt,
        payload: null,
      );
    }

    await widget.onSubmit(
      _titleController.text.trim(),
      _contentController.text.trim().isEmpty
          ? null
          : _contentController.text.trim(),
      reminder,
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
          // ===============================================================
          // Title
          // ===============================================================
          NoteTitleField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            enabled: !widget.isLoading,
            onSubmitted: (_) {
              _contentFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          // ===============================================================
          // Content
          // ===============================================================
          Expanded(
            child: NoteContentField(
              controller: _contentController,
              focusNode: _contentFocusNode,
              enabled: !widget.isLoading,
            ),
          ),

          const SizedBox(height: 20),

          // ===============================================================
          // Image Attachment
          // ===============================================================
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

                  OutlinedButton.icon(
                    onPressed: widget.isLoading
                        ? null
                        : provider.pickImageFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      provider.hasSelectedImage
                          ? 'Change Image'
                          : 'Attach Image',
                    ),
                  ),

                  if (provider.hasSelectedImage) ...[
                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(provider.selectedImagePath!),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      provider.selectedImagePath!,
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

          const SizedBox(height: 20),

          // ===============================================================
          // Reminder
          // ===============================================================
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    value: _reminderEnabled,
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Reminder'),
                    subtitle: const Text(
                      'Receive a local notification for this note.',
                    ),
                    onChanged: widget.isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _reminderEnabled = value;

                              if (!value) {
                                _selectedDate = null;
                                _selectedTime = null;
                              }
                            });
                          },
                  ),

                  if (_reminderEnabled) ...[
                    const Divider(height: 24),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Reminder Date'),
                      subtitle: Text(
                        _selectedDate == null
                            ? 'Select reminder date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: widget.isLoading ? null : _pickReminderDate,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time_outlined),
                      title: const Text('Reminder Time'),
                      subtitle: Text(
                        _selectedTime == null
                            ? 'Select reminder time'
                            : _selectedTime!.format(context),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: widget.isLoading ? null : _pickReminderTime,
                    ),

                    if (_hasValidReminder) ...[
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reminder Scheduled',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                    ' at ${_selectedTime!.format(context)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              tooltip: 'Remove Reminder',
                              onPressed: widget.isLoading
                                  ? null
                                  : _clearReminder,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_selectedDate != null ||
                        _selectedTime != null) ...[
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Theme.of(context).colorScheme.error,
                            ),

                            const SizedBox(width: 12),

                            const Expanded(
                              child: Text(
                                'Please select a future date and time.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ===============================================================
          // Submit Button
          // ===============================================================
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
