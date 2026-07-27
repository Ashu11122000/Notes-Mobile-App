import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/note.dart';

/// ============================================================================
/// File: note_card.dart
/// ============================================================================
///
/// Reusable Note Card.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays a single note.
/// • Handles user interactions through callbacks.
/// • Displays note metadata.
/// • Contains no business logic.
/// • Safe for ListView / SliverList usage.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// NoteCard
///  ↓
/// Callback
///  ↓
/// NotesProvider
///
/// ============================================================================

final class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  /// Note entity.
  final Note note;

  /// Called when card is tapped.
  final VoidCallback? onTap;

  /// Called when edit is selected.
  final VoidCallback? onEdit;

  /// Called when delete is selected.
  final VoidCallback? onDelete;

  static const double _cardRadius = 20;

  static const double _padding = 16;

  static const double _verticalMargin = 6;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      label: 'Note titled ${note.title}',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: _verticalMargin),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),

        clipBehavior: Clip.antiAlias,

        child: InkWell(
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(_padding),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                _buildHeader(context),

                const SizedBox(height: 12),

                _buildContent(theme),

                const SizedBox(height: 16),

                const Divider(height: 1),

                const SizedBox(height: 12),

                _buildFooter(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Header
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            note.title,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        _buildMenu(context),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopupMenuButton<_NoteCardAction>(
      tooltip: 'Note actions',

      icon: const Icon(Icons.more_vert_rounded),

      onSelected: _handleAction,

      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<_NoteCardAction>>[
          const PopupMenuItem(
            value: _NoteCardAction.edit,

            child: Row(
              children: <Widget>[
                Icon(Icons.edit_outlined),

                SizedBox(width: 12),

                Text('Edit'),
              ],
            ),
          ),

          PopupMenuItem(
            value: _NoteCardAction.delete,

            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.error,
                ),

                const SizedBox(width: 12),

                Text('Delete'),
              ],
            ),
          ),
        ];
      },
    );
  }

  void _handleAction(_NoteCardAction action) {
    switch (action) {
      case _NoteCardAction.edit:
        onEdit?.call();

      case _NoteCardAction.delete:
        onDelete?.call();
    }
  }

  // ===========================================================================
  // Content
  // ===========================================================================

  Widget _buildContent(ThemeData theme) {
    final String content = note.content?.trim() ?? '';

    return Text(
      content.isEmpty ? 'No content' : content,

      maxLines: 3,

      overflow: TextOverflow.ellipsis,

      style: theme.textTheme.bodyMedium?.copyWith(
        color: content.isEmpty ? theme.colorScheme.onSurfaceVariant : null,
      ),
    );
  }

  // ===========================================================================
  // Footer
  // ===========================================================================

  Widget _buildFooter(ThemeData theme) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.schedule_outlined,

          size: 16,

          color: theme.colorScheme.primary,
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            _formattedDate(),

            overflow: TextOverflow.ellipsis,

            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  String _formattedDate() {
    return DateFormat.yMMMd().add_jm().format(note.updatedAt);
  }
}

enum _NoteCardAction { edit, delete }
