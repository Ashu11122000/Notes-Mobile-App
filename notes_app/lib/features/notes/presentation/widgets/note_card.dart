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
/// • Optimized for ListView / SliverList.
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

  final Note note;

  final VoidCallback? onTap;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  // ===========================================================================
  // Layout Constants
  // ===========================================================================

  static const double _cardRadius = 20.0;

  static const double _padding = 16.0;

  static const double _verticalMargin = 6.0;

  static const double _contentSpacing = 12.0;

  static const double _footerSpacing = 16.0;

  static const double _iconSpacing = 6.0;

  // ===========================================================================
  // Cached Formatter
  // ===========================================================================

  static final DateFormat _dateFormatter = DateFormat.yMMMd().add_jm();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Semantics(
      button: onTap != null,
      label: 'Note titled ${note.title}',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: _verticalMargin),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildHeader(textTheme, colorScheme),

                const SizedBox(height: _contentSpacing),

                _buildContent(textTheme, colorScheme),

                const SizedBox(height: _footerSpacing),

                const Divider(height: 1),

                const SizedBox(height: _contentSpacing),

                _buildFooter(textTheme, colorScheme),
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

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _buildMenu(colorScheme),
      ],
    );
  }

  Widget _buildMenu(ColorScheme colorScheme) {
    return PopupMenuButton<_NoteCardAction>(
      tooltip: 'Note actions',
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: _handleAction,
      itemBuilder: (_) => <PopupMenuEntry<_NoteCardAction>>[
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
              Icon(Icons.delete_outline_rounded, color: colorScheme.error),
              SizedBox(width: 12),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(_NoteCardAction action) {
    switch (action) {
      case _NoteCardAction.edit:
        onEdit?.call();
        break;

      case _NoteCardAction.delete:
        onDelete?.call();
        break;
    }
  }

  // ===========================================================================
  // Content
  // ===========================================================================

  Widget _buildContent(TextTheme textTheme, ColorScheme colorScheme) {
    final String content = note.content?.trim() ?? '';

    final bool hasContent = content.isNotEmpty;

    return Text(
      hasContent ? content : 'No content',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(
        color: hasContent ? null : colorScheme.onSurfaceVariant,
      ),
    );
  }

  // ===========================================================================
  // Footer
  // ===========================================================================

  Widget _buildFooter(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      children: <Widget>[
        Icon(Icons.schedule_outlined, size: 16, color: colorScheme.primary),
        const SizedBox(width: _iconSpacing),
        Expanded(
          child: Text(
            _dateFormatter.format(note.updatedAt),
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

enum _NoteCardAction { edit, delete }
