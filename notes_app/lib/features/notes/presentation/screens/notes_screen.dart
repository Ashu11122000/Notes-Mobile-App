import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/features/notes/presentation/widgets/notes_list.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../constants/notes_constants.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';
import '../widgets/empty_notes_widget.dart';
import '../widgets/notes_fab.dart';
import '../widgets/notes_search_bar.dart';

/// ============================================================================
/// File: notes_screen.dart
/// ============================================================================
///
/// Notes Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays the authenticated user's notes.
/// - Supports pull-to-refresh.
/// - Supports infinite scrolling.
/// - Supports local searching.
/// - Navigates to:
///     • Add Note
///     • Edit Note
///     • Note Detail
/// - Uses NotesProvider for state management.
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

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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

    final provider = context.read<NotesProvider>();

    final position = _scrollController.position;

    if (position.pixels >=
        position.maxScrollExtent - NotesConstants.paginationThreshold) {
      provider.loadMore();
    }
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  void _onSearchChanged(String query) {
    final provider = context.read<NotesProvider>();

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
      appBar: AppBar(title: const Text('My Notes'), centerTitle: true),

      floatingActionButton: NotesFab(onPressed: _navigateToAddNote),

      body: Column(
        children: [
          //--------------------------------------------------------------------
          // Search Bar
          //--------------------------------------------------------------------
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

          //--------------------------------------------------------------------
          // Notes Content
          //--------------------------------------------------------------------
          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, provider, child) {
                // ===============================================================
                // Initial Loading
                // ===============================================================

                if (provider.isLoading && provider.notes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ===============================================================
                // Error State
                // ===============================================================

                if (provider.hasError && provider.notes.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 72,
                            color: Theme.of(context).colorScheme.error,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            'Unable to load notes',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            provider.errorMessage ??
                                'An unexpected error occurred.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),

                          const SizedBox(height: 24),

                          FilledButton.icon(
                            onPressed: () {
                              provider.loadNotes(refresh: true);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ===============================================================
                // Empty State
                // ===============================================================

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

                // ===============================================================
                // Notes List
                // ===============================================================

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

  Future<void> _navigateToAddNote() async {
    await context.push(AppRoutes.addNote);

    if (!mounted) {
      return;
    }

    await context.read<NotesProvider>().loadNotes(refresh: true);
  }

  Future<void> _navigateToEditNote(Note note) async {
    await context.push(AppRoutes.editNote, extra: note);

    if (!mounted) {
      return;
    }

    await context.read<NotesProvider>().loadNotes(refresh: true);
  }

  Future<void> _openNoteDetails(Note note) async {
    await context.push(AppRoutes.noteDetail, extra: note);

    if (!mounted) {
      return;
    }

    await context.read<NotesProvider>().loadNotes(refresh: true);
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

    await provider.deleteNote(note.id);

    if (!mounted) {
      return;
    }

    if (provider.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to delete note.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
