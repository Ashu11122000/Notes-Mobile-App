import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: note.dart
/// ============================================================================
///
/// Domain entity representing a Note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the core business object of the Notes feature.
/// • Independent of API, JSON, Dio, database, and Flutter infrastructure.
/// • Used by the domain and presentation layers only.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Presentation
///      ↓
/// Provider
///      ↓
/// Repository
///      ↓
/// Note (Entity)
///
/// ============================================================================

@immutable
class Note {
  const Note({
    required this.id,
    required this.ownerId,
    required this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique note identifier.
  final int id;

  /// Identifier of the user who owns this note.
  final int ownerId;

  /// Note title.
  final String title;

  /// Optional note content.
  final String? content;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last modification timestamp.
  final DateTime updatedAt;

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static String? _normalize(String? value) {
    final String? normalized = value?.trim();

    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Returns the normalized title.
  String get normalizedTitle => title.trim();

  /// Returns the normalized content.
  String? get normalizedContent => _normalize(content);

  /// Returns true when the note contains content.
  bool get hasContent => normalizedContent != null;

  /// Returns true when the note contains no meaningful data.
  bool get isEmpty => normalizedTitle.isEmpty && normalizedContent == null;

  /// Returns true when the note contains either a title or content.
  bool get isNotEmpty => !isEmpty;

  /// Returns a shortened title preview.
  ///
  /// Useful for compact list items.
  String get titlePreview {
    const int maxLength = 40;

    final String value = normalizedTitle;

    return value.length <= maxLength
        ? value
        : '${value.substring(0, maxLength)}...';
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  /// Creates a modified copy of this note.
  ///
  /// Use [clearContent] to explicitly remove the content.
  Note copyWith({
    int? id,
    int? ownerId,
    String? title,
    String? content,
    bool clearContent = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: clearContent ? null : (content ?? this.content),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Note &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            ownerId == other.ownerId &&
            title == other.title &&
            content == other.content &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt);
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerId, title, content, createdAt, updatedAt);

  // ===========================================================================
  // Debug
  // ===========================================================================

  @override
  String toString() {
    return 'Note('
        'id: $id, '
        'ownerId: $ownerId, '
        'title: $title, '
        'hasContent: $hasContent, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
