import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';

import '../../constants/notes_constants.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';
import '../widgets/empty_notes_widget.dart';
import '../widgets/notes_fab.dart';
import '../widgets/notes_list.dart';
import '../widgets/notes_search_bar.dart';

/// ============================================================================
/// File: notes_screen.dart
/// ============================================================================
///
/// Notes Screen.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays notes list.
/// • Handles searching.
/// • Handles pagination.
/// • Handles refresh.
/// • Handles navigation.
/// • Delegates state management to NotesProvider.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Call repository.
/// • Call API.
/// • Handle business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///    ↓
/// NotesProvider
///    ↓
/// NotesRepository
///    ↓
/// FastAPI
///
/// ============================================================================

final class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

final class _NotesScreenState extends State<NotesScreen> {
  // ===========================================================================
  // Controllers
  // ===========================================================================

  late final ScrollController _scrollController;

  late final TextEditingController _searchController;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _searchController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // Pagination
  // ===========================================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final NotesProvider provider = context.read<NotesProvider>();

    final ScrollPosition position = _scrollController.position;

    if (position.pixels >=
        position.maxScrollExtent - NotesConstants.paginationThreshold) {
      provider.loadMore();
    }
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  void _onSearchChanged(String query) {
    final NotesProvider provider = context.read<NotesProvider>();

    if (query.trim().isEmpty) {
      provider.clearSearch();

      return;
    }

    provider.search(query);
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),

        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Settings',

            icon: const Icon(Icons.settings_outlined),

            onPressed: _navigateToSettings,
          ),
        ],
      ),

      floatingActionButton: NotesFab(onPressed: _navigateToAddNote),

      body: Column(
        children: [
          // ===============================================================
          // Search
          // ===============================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

            child: NotesSearchBar(
              controller: _searchController,

              onChanged: _onSearchChanged,

              onClear: () {
                context.read<NotesProvider>().clearSearch();
              },
            ),
          ),

          // ===============================================================
          // Notes Content
          // ===============================================================
          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, provider, child) {
                // =========================================================
                // Initial Loading
                // =========================================================

                if (provider.isLoading && provider.notes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // =========================================================
                // Error State
                // =========================================================

                if (provider.hasError && provider.notes.isEmpty) {
                  return _ErrorView(
                    message: provider.errorMessage ?? 'Unable to load notes.',

                    onRetry: () {
                      provider.loadNotes(refresh: true);
                    },
                  );
                }

                // =========================================================
                // Empty State
                // =========================================================

                if (provider.notes.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await provider.loadNotes(refresh: true);
                    },

                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),

                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.72,

                          child: EmptyNotesWidget(
                            onCreatePressed: _navigateToAddNote,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // =========================================================
                // Notes List
                // =========================================================

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadNotes(refresh: true);
                  },

                  child: NoteList(
                    notes: provider.notes,

                    controller: _scrollController,

                    isLoadingMore: provider.isLoadingMore,

                    onNoteTap: _openNoteDetails,

                    onEdit: _navigateToEditNote,

                    onDelete: _deleteNote,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Navigation
  // ===========================================================================

  Future<void> _navigateToSettings() async {
    await context.push(AppRoutes.settings);
  }

  Future<void> _navigateToAddNote() async {
    await context.push(AppRoutes.addNote);
  }

  Future<void> _navigateToEditNote(Note note) async {
    await context.push(AppRoutes.editNote, extra: note);
  }

  Future<void> _openNoteDetails(Note note) async {
    await context.push(AppRoutes.noteDetail, extra: note);
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  Future<void> _deleteNote(Note note) async {
    final bool? confirmed = await DeleteNoteDialog.show(
      context,

      noteTitle: note.title,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final NotesProvider provider = context.read<NotesProvider>();

    provider.clearError();

    final bool deleted = await provider.deleteNote(note.id);

    if (!mounted) {
      return;
    }

    if (!deleted) {
      _showSnackBar(
        provider.errorMessage ?? 'Failed to delete note.',

        isError: true,
      );

      return;
    }

    _showSnackBar('Note deleted successfully.');
  }

  // ===========================================================================
  // Snackbar
  // ===========================================================================

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        behavior: SnackBarBehavior.floating,

        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

// ============================================================================
// Error View
// ============================================================================

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.error_outline_rounded,

              size: 72,

              color: theme.colorScheme.error,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load notes',

              style: theme.textTheme.titleLarge,

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message,

              textAlign: TextAlign.center,

              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: onRetry,

              icon: const Icon(Icons.refresh),

              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
