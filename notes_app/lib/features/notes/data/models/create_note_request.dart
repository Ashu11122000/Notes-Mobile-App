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
/// • Normalizes user input.
/// • Serializes data for the FastAPI backend.
/// • Remains immutable and strongly typed.
///
/// Example JSON
/// ----------------------------------------------------------------------------
///
/// With content:
///
/// {
///   "title": "Shopping List",
///   "content": "Buy milk and eggs."
/// }
///
/// Without content:
///
/// {
///   "title": "Shopping List"
/// }
///
/// ============================================================================

@immutable
final class CreateNoteRequest {
  const CreateNoteRequest({required this.title, this.content});

  // ===========================================================================
  // Fields
  // ===========================================================================

  /// Note title.
  final String title;

  /// Optional note content.
  final String? content;

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Returns normalized title.
  ///
  /// Removes leading and trailing spaces.
  String get normalizedTitle {
    return title.trim();
  }

  /// Returns normalized content.
  ///
  /// Returns null when:
  /// • Content is missing.
  /// • Content contains only spaces.
  String? get normalizedContent {
    final String? value = content?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  /// Returns true when title is valid.
  bool get isValid {
    return normalizedTitle.isNotEmpty;
  }

  /// Returns true when note contains content.
  bool get hasContent {
    return normalizedContent != null;
  }

  /// Returns true when request can be submitted.
  bool get canSubmit {
    return isValid;
  }

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts request into FastAPI compatible JSON.
  ///
  /// Empty content is intentionally removed from payload.
  /// This keeps API requests cleaner.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'title': normalizedTitle,
    };

    final String? cleanContent = normalizedContent;

    if (cleanContent != null) {
      json['content'] = cleanContent;
    }

    return json;
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
            other.title == title &&
            other.content == content;
  }

  @override
  int get hashCode {
    return Object.hash(title, content);
  }

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
