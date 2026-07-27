import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifications/models/reminder_model.dart';
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
/// • Shared form for creating and editing notes.
/// • Handles validation.
/// • Handles local UI state.
/// • Supports image attachment.
/// • Supports reminder selection.
/// • Emits final data through callbacks.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Call repositories.
/// • Call APIs.
/// • Manage business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Screen
///    ↓
/// NoteForm
///    ↓
/// onSubmit(...)
///    ↓
/// NotesProvider
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

  /// Initial note title.
  final String initialTitle;

  /// Initial note content.
  final String initialContent;

  /// Submit button label.
  final String submitLabel;

  /// Controls loading state.
  final bool isLoading;

  /// Called when form is successfully submitted.
  final Future<void> Function(
    String title,
    String? content,
    ReminderModel? reminder,
  )
  onSubmit;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

/// ============================================================================
/// Form State
/// ============================================================================

final class _NoteFormState extends State<NoteForm> {
  // ===========================================================================
  // Constants
  // ===========================================================================

  static const int _maxReminderYears = 5;

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

      lastDate: DateTime(now.year + _maxReminderYears),

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

  void _toggleReminder(bool enabled) {
    setState(() {
      _reminderEnabled = enabled;

      if (!enabled) {
        _selectedDate = null;
        _selectedTime = null;
      }
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
        notificationId: DateTime.now().millisecondsSinceEpoch,

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

  // ===========================================================================
  // Widgets
  // ===========================================================================

  Widget _AttachmentCard({
    required NotesProvider provider,
    required bool enabled,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.attach_file_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                enabled ? 'Attachment support available' : 'Attachment unavailable while saving',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ReminderCard({
    required bool enabled,
    required bool reminderEnabled,
    required DateTime? selectedDate,
    required TimeOfDay? selectedTime,
    required bool hasValidReminder,
    required void Function(bool) onToggle,
    required VoidCallback onPickDate,
    required VoidCallback onPickTime,
    required VoidCallback onClear,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: reminderEnabled,
              onChanged: enabled ? onToggle : null,
              title: const Text('Reminder'),
              subtitle: const Text('Set a reminder for this note'),
            ),
            if (reminderEnabled) ...<Widget>[
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: enabled ? onPickDate : null,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        selectedDate == null
                            ? 'Pick date'
                            : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: enabled ? onPickTime : null,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime == null
                            ? 'Pick time'
                            : selectedTime.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    hasValidReminder
                        ? 'Reminder is ready'
                        : 'Select a future date and time',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: enabled ? onClear : null,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final NotesProvider provider = context.watch<NotesProvider>();

    return Form(
      key: _formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          // ===================================================================
          // Title
          // ===================================================================
          NoteTitleField(
            controller: _titleController,

            focusNode: _titleFocusNode,

            enabled: !widget.isLoading,

            onSubmitted: (_) {
              _contentFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 16),

          // ===================================================================
          // Content
          // ===================================================================
          Expanded(
            child: NoteContentField(
              controller: _contentController,

              focusNode: _contentFocusNode,

              enabled: !widget.isLoading,
            ),
          ),

          const SizedBox(height: 20),

          // ===================================================================
          // Image Attachment
          // ===================================================================
          _AttachmentCard(provider: provider, enabled: !widget.isLoading),

          const SizedBox(height: 20),

          // ===================================================================
          // Reminder
          // ===================================================================
          _ReminderCard(
            enabled: !widget.isLoading,

            reminderEnabled: _reminderEnabled,

            selectedDate: _selectedDate,

            selectedTime: _selectedTime,

            hasValidReminder: _hasValidReminder,

            onToggle: _toggleReminder,

            onPickDate: _pickReminderDate,

            onPickTime: _pickReminderTime,

            onClear: _clearReminder,
          ),

          const SizedBox(height: 24),

          // ===================================================================
          // Submit Button
          // ===================================================================
          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              onPressed: widget.isLoading ? null : _submit,

              icon: widget.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
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
