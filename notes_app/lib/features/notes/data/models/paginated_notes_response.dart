import '../../../../shared/models/pagination_meta.dart';
import '../../../../shared/models/pagination_response.dart';
import 'note_model.dart';

/// =============================================================================
/// File: paginated_notes_response.dart
/// =============================================================================
///
/// Typed paginated response for Notes.
///
/// This wraps the generic [PaginationResponse] while providing a strongly typed
/// API for the Notes feature.
///
/// Example JSON:
///
/// {
///   "items": [
///     {
///       "id": "...",
///       "title": "...",
///       "content": "...",
///       "is_archived": false,
///       "created_at": "...",
///       "updated_at": "..."
///     }
///   ],
///   "meta": {
///     "page": 1,
///     "size": 10,
///     "total": 25,
///     "pages": 3
///   }
/// }
///
class PaginatedNotesResponse extends PaginationResponse<NoteModel> {
  const PaginatedNotesResponse({required super.items, required super.meta});

  /// Creates a paginated notes response from JSON.
  factory PaginatedNotesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedNotesResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => NoteModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      meta: PaginationMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  /// Converts this response to JSON.
  @override
  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(NoteModel item) toJsonT,
  ) {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'meta': meta.toJson(),
    };
  }

  /// Returns a copy with updated values.
  @override
  PaginatedNotesResponse copyWith({
    List<NoteModel>? items,
    PaginationMeta? meta,
  }) {
    return PaginatedNotesResponse(
      items: items ?? this.items,
      meta: meta ?? this.meta,
    );
  }

  @override
  String toString() {
    return 'PaginatedNotesResponse('
        'items: $items, '
        'meta: $meta'
        ')';
  }
}
