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
/// Enterprise Note Form.
///
/// Shared between:
/// • Create Note
/// • Edit Note
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Owns only UI state.
/// • Validates user input.
/// • Builds reminder information.
/// • Delegates persistence through callbacks.
/// • Contains no repository or networking logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Screen
///     ↓
/// NoteForm
///     ↓
/// Callback
///     ↓
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

  /// Initial title.
  final String initialTitle;

  /// Initial content.
  final String initialContent;

  /// Submit button label.
  final String submitLabel;

  /// Loading indicator.
  final bool isLoading;

  /// Called after successful validation.
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
/// State
/// ============================================================================

final class _NoteFormState extends State<NoteForm> {
  // ===========================================================================
  // Constants
  // ===========================================================================

  static const int _maxReminderYears = 5;

  static const double _sectionSpacing = 20.0;

  static const double _fieldSpacing = 16.0;

  static const double _buttonSpacing = 24.0;

  static const double _bottomSpacing = 12.0;

  // ===========================================================================
  // Form
  // ===========================================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;

  late final TextEditingController _contentController;

  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _contentFocusNode = FocusNode();

  // ===========================================================================
  // Reminder
  // ===========================================================================

  bool _reminderEnabled = false;

  DateTime? _selectedDate;

  TimeOfDay? _selectedTime;

  // ===========================================================================
  // Getters
  // ===========================================================================

  bool get _hasReminder =>
      _reminderEnabled && _selectedDate != null && _selectedTime != null;

  String get _trimmedTitle => _titleController.text.trim();

  String? get _trimmedContent {
    final String value = _contentController.text.trim();

    return value.isEmpty ? null : value;
  }

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
    if (widget.isLoading) {
      return;
    }

    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + _maxReminderYears),
    );

    if (pickedDate == null || pickedDate == _selectedDate) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _pickReminderTime() async {
    if (widget.isLoading) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null || pickedTime == _selectedTime) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _toggleReminder(bool enabled) {
    if (_reminderEnabled == enabled) {
      return;
    }

    setState(() {
      _reminderEnabled = enabled;

      if (!enabled) {
        _selectedDate = null;
        _selectedTime = null;
      }
    });
  }

  void _clearReminder() {
    if (!_reminderEnabled && _selectedDate == null && _selectedTime == null) {
      return;
    }

    setState(() {
      _reminderEnabled = false;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  DateTime? _buildReminderDateTime() {
    final DateTime? date = _selectedDate;
    final TimeOfDay? time = _selectedTime;

    if (date == null || time == null) {
      return null;
    }

    final DateTime scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return scheduledAt.isAfter(DateTime.now()) ? scheduledAt : null;
  }

  // ===========================================================================
  // Submit
  // ===========================================================================

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    ReminderModel? reminder;

    if (_hasReminder) {
      final DateTime? scheduledAt = _buildReminderDateTime();

      if (scheduledAt == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Please select a future '
                'date and time.',
              ),
            ),
          );

        return;
      }

      reminder = ReminderModel(
        notificationId: DateTime.now().millisecondsSinceEpoch,

        noteId: 0,

        title: _trimmedTitle,

        body: _trimmedContent ?? 'Reminder for your note',

        scheduledAt: scheduledAt,

        payload: null,
      );
    }

    await widget.onSubmit(_trimmedTitle, _trimmedContent, reminder);
  }

  // ===========================================================================
  // UI Helpers
  // ===========================================================================

  Widget _buildAttachmentCard(BuildContext context, NotesProvider provider) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final bool enabled = !widget.isLoading;
    final File? image = provider.selectedImage;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(Icons.attach_file_outlined, color: colorScheme.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                image == null
                    ? 'No image selected'
                    : image.path.split(Platform.pathSeparator).last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
            ),

            IconButton(
              tooltip: 'Pick image',

              onPressed: enabled ? provider.pickImageFromGallery : null,

              icon: const Icon(Icons.image_outlined),
            ),

            if (image != null)
              IconButton(
                tooltip: 'Remove image',

                onPressed: enabled ? provider.removeSelectedImage : null,

                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.zero,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,

              title: const Text('Reminder'),

              subtitle: const Text('Notify me later'),

              value: _reminderEnabled,

              onChanged: widget.isLoading ? null : _toggleReminder,
            ),

            if (_reminderEnabled) ...<Widget>[
              const SizedBox(height: 8),

              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.isLoading ? null : _pickReminderDate,

                      icon: const Icon(Icons.calendar_today_outlined),

                      label: Text(
                        _selectedDate == null
                            ? 'Date'
                            : '${_selectedDate!.day}/'
                                  '${_selectedDate!.month}/'
                                  '${_selectedDate!.year}',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.isLoading ? null : _pickReminderTime,

                      icon: const Icon(Icons.schedule_outlined),

                      label: Text(
                        _selectedTime == null
                            ? 'Time'
                            : _selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _buildReminderDateTime() != null
                          ? 'Reminder ready'
                          : 'Select a future date & time',
                      style: textTheme.bodySmall,
                    ),
                  ),

                  TextButton(
                    onPressed: widget.isLoading ? null : _clearReminder,

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
    final bool hasSelectedImage = context.select<NotesProvider, bool>(
      (NotesProvider provider) => provider.selectedImage != null,
    );

    final File? selectedImage = context.select<NotesProvider, File?>(
      (NotesProvider provider) => provider.selectedImage,
    );

    final NotesProvider provider = context.read<NotesProvider>();

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double bottomInset = mediaQuery.viewInsets.bottom;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

        padding: EdgeInsets.only(bottom: bottomInset),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
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

            const SizedBox(height: _fieldSpacing),

            // ===============================================================
            // Content
            // ===============================================================
            NoteContentField(
              controller: _contentController,
              focusNode: _contentFocusNode,
              enabled: !widget.isLoading,
            ),

            const SizedBox(height: _sectionSpacing),

            // ===============================================================
            // Attachment
            // ===============================================================
            _buildAttachmentCard(context, provider),

            if (hasSelectedImage && selectedImage != null) ...<Widget>[
              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: Image.file(
                  selectedImage,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  filterQuality: FilterQuality.low,
                ),
              ),
            ],

            const SizedBox(height: _sectionSpacing),

            // ===============================================================
            // Reminder
            // ===============================================================
            _buildReminderCard(context),

            const SizedBox(height: _buttonSpacing),

            // ===============================================================
            // Submit Button
            // ===============================================================
            FilledButton.icon(
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

            const SizedBox(height: _bottomSpacing),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Utility Helpers
  // ===========================================================================

  /// Clears keyboard focus.
  ///
  /// Useful after a successful submit.
  void _dismissKeyboard() {
    final FocusScopeNode focusScope = FocusScope.of(context);

    if (!focusScope.hasPrimaryFocus) {
      focusScope.unfocus();
    }
  }

  /// Resets reminder state.
  ///
  /// Does not clear the text fields because they may still be needed
  /// after a failed submission.
  void _resetReminderState() {
    if (!_reminderEnabled && _selectedDate == null && _selectedTime == null) {
      return;
    }

    setState(() {
      _reminderEnabled = false;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  /// Clears the selected image through the provider.
  void _clearSelectedImage(NotesProvider provider) {
    if (provider.selectedImage == null) {
      return;
    }

    provider.removeSelectedImage();
  }

  /// Resets transient UI state after a successful save.
  ///
  /// This intentionally does not clear the form fields because
  /// create/edit screens may have different navigation flows.
  void _afterSuccessfulSubmit(NotesProvider provider) {
    _dismissKeyboard();
    _resetReminderState();
    _clearSelectedImage(provider);
  }
}
