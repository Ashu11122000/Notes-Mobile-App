import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';

import '../../constants/notes_constants.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/delete_note_dialog.dart';
import '../widgets/empty_notes_widget.dart';
import '../widgets/notes_list.dart';
import '../widgets/notes_fab.dart';
import '../widgets/notes_search_bar.dart';

/// ============================================================================
/// File: notes_screen.dart
/// ============================================================================
///
/// Notes Screen.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays notes.
/// • Handles searching.
/// • Handles refresh.
/// • Handles pagination.
/// • Handles navigation.
/// • Delegates state management to NotesProvider.
///
/// Contains no business logic.
///
/// ============================================================================

final class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

final class _NotesScreenState extends State<NotesScreen> {
  // ===========================================================================
  // Constants
  // ===========================================================================

  static const EdgeInsets _searchPadding = EdgeInsets.fromLTRB(16, 16, 16, 8);

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
      if (!mounted) {
        return;
      }

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

    final ScrollPosition position = _scrollController.position;

    if (position.pixels <
        position.maxScrollExtent - NotesConstants.paginationThreshold) {
      return;
    }

    context.read<NotesProvider>().loadMore();
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
    final bool isLoading = context.select<NotesProvider, bool>(
      (provider) => provider.isLoading,
    );

    final bool isLoadingMore = context.select<NotesProvider, bool>(
      (provider) => provider.isLoadingMore,
    );

    final bool hasError = context.select<NotesProvider, bool>(
      (provider) => provider.hasError,
    );

    final String? errorMessage = context.select<NotesProvider, String?>(
      (provider) => provider.errorMessage,
    );

    final List<Note> notes = context.select<NotesProvider, List<Note>>(
      (provider) => provider.notes,
    );

    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _navigateToSettings,
          ),
        ],
      ),

      floatingActionButton: NotesFab(onPressed: _navigateToAddNote),

      body: Column(
        children: <Widget>[
          Padding(
            padding: _searchPadding,
            child: NotesSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                context.read<NotesProvider>().clearSearch();
              },
            ),
          ),

          Expanded(
            child: _buildBody(
              context,
              screenHeight,
              notes,
              isLoading,
              isLoadingMore,
              hasError,
              errorMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    double screenHeight,
    List<Note> notes,
    bool isLoading,
    bool isLoadingMore,
    bool hasError,
    String? errorMessage,
  ) {
    if (isLoading && notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError && notes.isEmpty) {
      return _ErrorView(
        message: errorMessage ?? 'Unable to load notes.',
        onRetry: () {
          context.read<NotesProvider>().loadNotes(refresh: true);
        },
      );
    }

    if (notes.isEmpty) {
      return RefreshIndicator(
        onRefresh: () {
          return context.read<NotesProvider>().loadNotes(refresh: true);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: screenHeight * .72,
              child: EmptyNotesWidget(onCreatePressed: _navigateToAddNote),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return context.read<NotesProvider>().loadNotes(refresh: true);
      },
      child: NoteList(
        notes: notes,
        controller: _scrollController,
        isLoadingMore: isLoadingMore,
        onNoteTap: _openNoteDetails,
        onEdit: _navigateToEditNote,
        onDelete: _deleteNote,
      ),
    );
  }

  // ===========================================================================
  // Navigation
  // ===========================================================================

  Future<void> _navigateToSettings() => context.push(AppRoutes.settings);

  Future<void> _navigateToAddNote() => context.push(AppRoutes.addNote);

  Future<void> _navigateToEditNote(Note note) =>
      context.push(AppRoutes.editNote, extra: note);

  Future<void> _openNoteDetails(Note note) =>
      context.push(AppRoutes.noteDetail, extra: note);

  // ===========================================================================
  // Delete
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
