import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: create_note_request.dart
/// ============================================================================
///
/// Immutable request model for creating a new note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the request body for the Create Note API.
/// • Performs lightweight input normalization.
/// • Provides simple validation helpers.
/// • Serializes data for the FastAPI backend.
/// • Contains no business logic.
///
/// Example JSON
/// ----------------------------------------------------------------------------
/// {
///   "title": "Shopping List",
///   "content": "Buy milk and eggs."
/// }
///
/// Content is omitted when it is null or contains only whitespace.
/// ============================================================================

@immutable
final class CreateNoteRequest {
  const CreateNoteRequest({required this.title, this.content});

  // ===========================================================================
  // Fields
  // ===========================================================================

  /// Raw note title entered by the user.
  final String title;

  /// Raw optional note content.
  final String? content;

  // ===========================================================================
  // Normalized Values
  // ===========================================================================

  /// Title with surrounding whitespace removed.
  String get normalizedTitle => title.trim();

  /// Content with surrounding whitespace removed.
  ///
  /// Returns `null` when:
  /// - content is null
  /// - content contains only whitespace
  String? get normalizedContent {
    final String? value = content?.trim();

    return (value == null || value.isEmpty) ? null : value;
  }

  // ===========================================================================
  // Validation
  // ===========================================================================

  /// Returns true when the title contains at least one non-whitespace character.
  bool get isValid => normalizedTitle.isNotEmpty;

  /// Returns true when content exists after normalization.
  bool get hasContent => normalizedContent != null;

  /// Returns true when the request is ready to be submitted.
  bool get canSubmit => isValid;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts this request into the JSON payload expected by the FastAPI backend.
  ///
  /// Empty content is intentionally omitted.
  Map<String, dynamic> toJson() {
    final String normalizedTitle = this.normalizedTitle;
    final String? normalizedContent = this.normalizedContent;

    return <String, dynamic>{
      'title': normalizedTitle,
      if (normalizedContent != null) 'content': normalizedContent,
    };
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  /// Creates a modified copy of this request.
  ///
  /// Use [clearContent] to explicitly remove existing content.
  CreateNoteRequest copyWith({
    String? title,
    String? content,
    bool clearContent = false,
  }) {
    return CreateNoteRequest(
      title: title ?? this.title,
      content: clearContent ? null : (content ?? this.content),
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateNoteRequest &&
            other.title == title &&
            other.content == content);
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
