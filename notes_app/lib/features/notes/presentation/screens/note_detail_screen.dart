import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';

/// ============================================================================
/// File: note_detail_screen.dart
/// ============================================================================
///
/// Displays complete note information.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays note details.
/// • Allows editing.
/// • Allows deleting.
/// • Delegates actions to NotesProvider.
/// • Contains no business logic.
///
/// ============================================================================

final class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.note});

  final Note note;

  static const EdgeInsets _pagePadding = EdgeInsets.all(20);

  static final DateFormat _dateFormatter = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select<NotesProvider, bool>(
      (NotesProvider provider) => provider.isLoading,
    );

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Edit note',
            icon: const Icon(Icons.edit_outlined),
            onPressed: isLoading
                ? null
                : () {
                    context.push(AppRoutes.editNote, extra: note);
                  },
          ),
          IconButton(
            tooltip: 'Delete note',
            icon: const Icon(Icons.delete_outline),
            onPressed: isLoading ? null : () => _deleteNote(context),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              padding: _pagePadding,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(note.title, style: textTheme.headlineMedium),

                  const SizedBox(height: 24),

                  SelectableText(
                    note.hasContent ? note.content! : 'No content available.',
                    style: textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 32),

                  const Divider(),

                  const SizedBox(height: 16),

                  _InfoTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Created',
                    value: _dateFormatter.format(note.createdAt),
                  ),

                  const SizedBox(height: 12),

                  _InfoTile(
                    icon: Icons.update_outlined,
                    title: 'Last Updated',
                    value: _dateFormatter.format(note.updatedAt),
                  ),
                ],
              ),
            ),
          ),

          if (isLoading)
            const ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Delete
  // ===========================================================================

  Future<void> _deleteNote(BuildContext context) async {
    final bool? confirmed = await DeleteNoteDialog.show(
      context,
      noteTitle: note.title,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final NotesProvider provider = context.read<NotesProvider>();

    provider.clearError();

    final bool deleted = await provider.deleteNote(note.id);

    if (!context.mounted) {
      return;
    }

    if (!deleted) {
      CustomSnackBar.show(
        context,
        message: provider.errorMessage ?? 'Failed to delete note.',
        type: SnackbarType.error,
      );
      return;
    }

    CustomSnackBar.show(
      context,
      message: 'Note deleted successfully.',
      type: SnackbarType.success,
    );

    context.pop(true);
  }
}

/// ============================================================================
/// Note Metadata Tile
/// ============================================================================

final class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;

  final String title;

  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: theme.colorScheme.primary),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: theme.textTheme.labelMedium),

              const SizedBox(height: 4),

              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
