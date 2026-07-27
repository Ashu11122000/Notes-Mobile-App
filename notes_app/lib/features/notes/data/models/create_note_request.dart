import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: create_note_request.dart
/// ============================================================================
///
/// Request model for creating a new note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the Create Note request body.
/// • Provides lightweight validation.
/// • Serializes data for the FastAPI backend.
/// • Remains immutable and strongly typed.
///
/// Example JSON
/// ----------------------------------------------------------------------------
/// {
///   "title": "Shopping List",
///   "content": "Buy milk and eggs."
/// }
///
/// ============================================================================

@immutable
final class CreateNoteRequest {
  const CreateNoteRequest({required this.title, this.content});

  /// Note title.
  final String title;

  /// Optional note content.
  final String? content;

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Normalized title.
  String get normalizedTitle => title.trim();

  /// Normalized content.
  ///
  /// Returns null when the content is empty after trimming.
  String? get normalizedContent {
    final String? value = content?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  /// Returns true when the title is valid.
  bool get isValid => normalizedTitle.isNotEmpty;

  /// Returns true when content exists.
  bool get hasContent => normalizedContent != null;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts this request into the JSON format expected by FastAPI.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': normalizedTitle,
      'content': normalizedContent,
    };
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  CreateNoteRequest copyWith({String? title, String? content}) {
    return CreateNoteRequest(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CreateNoteRequest &&
            title == other.title &&
            content == other.content;
  }

  @override
  int get hashCode => Object.hash(title, content);

  // ===========================================================================
  // Debugging
  // ===========================================================================

  @override
  String toString() {
    return 'CreateNoteRequest('
        'title: $title, '
        'content: $content'
        ')';
  }
}
