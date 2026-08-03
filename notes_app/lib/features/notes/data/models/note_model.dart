import '../../domain/entities/note.dart';

/// ============================================================================
/// File: note_model.dart
/// ============================================================================
///
/// Data model for a Note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Parses JSON received from the FastAPI backend.
/// • Serializes model data into JSON.
/// • Maps between the data layer and domain layer.
/// • Remains fully compatible with the [Note] domain entity.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// FastAPI JSON
///        ↓
///    NoteModel
///        ↓
///       Note
///
/// ============================================================================

final class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.ownerId,
    required super.title,
    super.content,
    required super.createdAt,
    required super.updatedAt,
  });

  // ===========================================================================
  // Factories
  // ===========================================================================

  /// Creates a model from backend JSON.
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final DateTime createdAt = DateTime.parse(json['created_at'] as String);

    return NoteModel(
      id: (json['id'] as num).toInt(),
      ownerId: (json['owner_id'] as num).toInt(),
      title: (json['title'] as String).trim(),
      content: _normalizeContent(json['content'] as String?),
      createdAt: createdAt,
      updatedAt: json['updated_at'] == null
          ? createdAt
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Creates a model from a domain entity.
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      ownerId: note.ownerId,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static String? _normalizeContent(String? value) {
    final String? normalized = value?.trim();

    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Returns true when the note contains content.
  bool get hasContent => content != null;

  /// Returns true when the note contains no meaningful data.
  bool get isEmpty {
    final String normalizedTitle = title.trim();

    return normalizedTitle.isEmpty && _normalizeContent(content) == null;
  }

  /// Returns true when the note contains either a title or content.
  bool get isNotEmpty => !isEmpty;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts the model into JSON expected by the FastAPI backend.
  Map<String, dynamic> toJson() {
    final String normalizedTitle = title.trim();
    final String? normalizedContent = _normalizeContent(content);

    return <String, dynamic>{
      'id': id,
      'owner_id': ownerId,
      'title': normalizedTitle,
      'content': normalizedContent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converts the model into the domain entity.
  Note toEntity() {
    return Note(
      id: id,
      ownerId: ownerId,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  @override
  NoteModel copyWith({
    int? id,
    int? ownerId,
    String? title,
    String? content,
    bool clearContent = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: clearContent ? null : (content ?? this.content),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ===========================================================================
  // Debug
  // ===========================================================================

  @override
  String toString() {
    return 'NoteModel('
        'id: $id, '
        'ownerId: $ownerId, '
        'title: $title, '
        'hasContent: $hasContent, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
