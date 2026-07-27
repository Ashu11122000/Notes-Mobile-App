import '../../domain/entities/note.dart';

/// ============================================================================
/// File: note_model.dart
/// ============================================================================
///
/// Data model for Note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Parses JSON received from the FastAPI backend.
/// • Serializes models into JSON.
/// • Maps between the data layer and the domain layer.
/// • Preserves full compatibility with the domain [Note] entity.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// FastAPI JSON
///        ↓
///    NoteModel
///        ↓
///      Note
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

    final DateTime updatedAt = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : createdAt;

    return NoteModel(
      id: (json['id'] as num).toInt(),
      ownerId: (json['owner_id'] as num).toInt(),
      title: (json['title'] as String).trim(),
      content: _normalizeContent(json['content'] as String?),
      createdAt: createdAt,
      updatedAt: updatedAt,
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
    final String? trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  /// Returns true when this note contains content.
  bool get hasContent => content != null;

  /// Returns true when this note is empty.
  bool get isEmpty =>
      title.trim().isEmpty && (content == null || content!.trim().isEmpty);

  /// Returns true when this note has either a title or content.
  bool get isNotEmpty => !isEmpty;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts the model into backend JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'owner_id': ownerId,
      'title': title.trim(),
      'content': _normalizeContent(content),
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: content ?? this.content,
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
        'content: $content, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
