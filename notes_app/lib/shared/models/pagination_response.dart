import 'package:flutter/foundation.dart';

import 'pagination_meta.dart';

/// ============================================================================
/// File: pagination_response.dart
/// ============================================================================
///
/// Represents a generic paginated response returned by an API.
///
/// This model is intentionally feature-independent and reusable across
/// multiple modules including:
///
/// - Notes
/// - Tasks
/// - Users
/// - Notifications
/// - Analytics
///
/// It combines:
///
/// - A collection of items.
/// - Pagination metadata.
///
/// The concrete item type is supplied through the generic type parameter [T].
///
/// This class intentionally contains no business logic and remains independent
/// of any specific backend implementation.
///
/// Example JSON:
///
/// ```json
/// {
///   "items": [
///     { ... }
///   ],
///   "meta": {
///     "page": 1,
///     "size": 10,
///     "total": 42,
///     "pages": 5
///   }
/// }
/// ```
///
/// Although the current Notes API returns only a `List<NoteResponse>`, this
/// model is retained as a reusable foundation for future paginated endpoints.
@immutable
final class PaginationResponse<T> {
  /// Creates an immutable paginated response.
  const PaginationResponse({required this.items, required this.meta});

  /// Creates a paginated response from JSON.
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsJson = (json['items'] as List<dynamic>?) ?? const <dynamic>[];

    return PaginationResponse<T>(
      items: List<T>.unmodifiable(
        itemsJson.map(
          (item) => fromJsonT(Map<String, dynamic>.from(item as Map)),
        ),
      ),
      meta: PaginationMeta.fromJson(
        Map<String, dynamic>.from(
          (json['meta'] as Map?) ?? const <String, dynamic>{},
        ),
      ),
    );
  }

  /// Items returned for the current page.
  final List<T> items;

  /// Pagination metadata.
  final PaginationMeta meta;

  /// Converts this response into JSON.
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T item) toJsonT) {
    return {
      'items': items.map<Map<String, dynamic>>(toJsonT).toList(growable: false),
      'meta': meta.toJson(),
    };
  }

  /// Creates a copy with updated values.
  PaginationResponse<T> copyWith({List<T>? items, PaginationMeta? meta}) {
    return PaginationResponse<T>(
      items: items != null ? List<T>.unmodifiable(items) : this.items,
      meta: meta ?? this.meta,
    );
  }

  /// Maps every item while preserving pagination metadata.
  ///
  /// Useful for converting DTOs into domain entities.
  PaginationResponse<R> map<R>(R Function(T item) mapper) {
    return PaginationResponse<R>(
      items: List<R>.unmodifiable(items.map(mapper)),
      meta: meta,
    );
  }

  /// Returns whether another page exists.
  bool get hasNextPage => meta.hasNextPage;

  /// Returns whether a previous page exists.
  bool get hasPreviousPage => meta.hasPreviousPage;

  /// Returns whether this page contains no items.
  bool get isEmpty => items.isEmpty;

  /// Returns whether this page contains at least one item.
  bool get isNotEmpty => items.isNotEmpty;

  /// Number of items in the current page.
  int get itemCount => items.length;

  /// Current page number.
  int get currentPage => meta.page;

  /// Total number of pages.
  int get totalPages => meta.pages;

  /// Total number of records.
  int get totalItems => meta.total;

  /// Next page number.
  int get nextPage => meta.nextPage;

  /// Previous page number.
  int get previousPage => meta.previousPage;

  @override
  String toString() =>
      '$runtimeType('
      'itemCount: $itemCount, '
      'meta: $meta'
      ')';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginationResponse<T> &&
            listEquals(items, other.items) &&
            meta == other.meta;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(items), meta);
}
