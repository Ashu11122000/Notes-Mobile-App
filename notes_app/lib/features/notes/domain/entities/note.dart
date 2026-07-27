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
/// • Independent from API, JSON, Dio, database, and Flutter infrastructure.
/// • Used by domain and presentation layers.
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

  /// User identifier who owns this note.
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
  // Computed Properties
  // ===========================================================================

  /// Returns true when this note contains content.
  bool get hasContent {
    final String? value = content?.trim();

    return value != null && value.isNotEmpty;
  }

  /// Returns true when the note has no meaningful text.
  bool get isEmpty {
    return title.trim().isEmpty && !hasContent;
  }

  /// Returns true when the note contains useful data.
  bool get isNotEmpty => !isEmpty;

  /// Returns a shortened title preview.
  ///
  /// Useful for list cards and compact UI components.
  String get titlePreview {
    const int maxLength = 40;

    final String value = title.trim();

    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength)}...';
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  /// Creates a copy with updated values.
  Note copyWith({
    int? id,
    int? ownerId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: content ?? this.content,
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
        other is Note &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            ownerId == other.ownerId &&
            title == other.title &&
            content == other.content &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, ownerId, title, content, createdAt, updatedAt);
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  @override
  String toString() {
    return 'Note('
        'id: $id, '
        'ownerId: $ownerId, '
        'title: $title, '
        'content: $content, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
