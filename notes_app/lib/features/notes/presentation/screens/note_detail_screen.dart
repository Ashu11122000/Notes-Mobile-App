import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';

/// ============================================================================
/// File: note_detail_screen.dart
/// ============================================================================
///
/// Note Detail Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays complete information about a note.
/// - Allows editing.
/// - Allows deleting.
/// - Delegates CRUD operations to NotesProvider.
/// - Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesProvider
///     ↓
/// NotesRepository
///     ↓
/// FastAPI
///
/// ============================================================================

final class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.note});

  /// Note to display.
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Note Details'),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: provider.isLoading
                    ? null
                    : () {
                        context.push(AppRoutes.editNote, extra: note);
                      },
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: provider.isLoading
                    ? null
                    : () => _deleteNote(context, provider),
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //----------------------------------------------------------------
                      // Title
                      //----------------------------------------------------------------
                      Text(
                        note.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 24),

                      //----------------------------------------------------------------
                      // Content
                      //----------------------------------------------------------------
                      SelectableText(
                        note.content?.trim().isNotEmpty == true
                            ? note.content!
                            : 'No content available.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 32),

                      const Divider(),

                      const SizedBox(height: 16),

                      //----------------------------------------------------------------
                      // Metadata
                      //----------------------------------------------------------------
                      _InfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'Created',
                        value: _formatDate(note.createdAt),
                      ),

                      const SizedBox(height: 12),

                      _InfoTile(
                        icon: Icons.update_outlined,
                        title: 'Last Updated',
                        value: _formatDate(note.updatedAt),
                      ),
                    ],
                  ),
                ),
              ),

              if (provider.isLoading)
                const ColoredBox(
                  color: Color(0x33000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  Future<void> _deleteNote(BuildContext context, NotesProvider provider) async {
    final bool? confirmed = await DeleteNoteDialog.show(
      context,
      noteTitle: note.title,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    provider.clearError();

    await provider.deleteNote(note.id);

    if (!context.mounted) {
      return;
    }

    if (provider.hasError) {
      _showErrorSnackBar(
        context,
        provider.errorMessage ?? 'Failed to delete note.',
      );
      return;
    }

    _showSuccessSnackBar(context);

    context.pop();
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
