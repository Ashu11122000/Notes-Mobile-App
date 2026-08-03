import 'package:flutter/foundation.dart';

import 'pagination_meta.dart';

/// ============================================================================
/// File: pagination_response.dart
/// ============================================================================
///
/// Represents a generic paginated response.
///
/// This model is feature-independent and reusable across multiple modules,
/// including:
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
@immutable
final class PaginationResponse<T> {
  /// Creates an immutable paginated response.
  const PaginationResponse({required this.items, required this.meta});

  /// Creates a paginated response from JSON.
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawItems = json['items'];

    final items = rawItems is List
        ? List<T>.unmodifiable(
            rawItems.map(
              (item) => fromJsonT(Map<String, dynamic>.from(item as Map)),
            ),
          )
        : <T>[];

    final rawMeta = json['meta'];

    return PaginationResponse<T>(
      items: items,
      meta: PaginationMeta.fromJson(
        rawMeta is Map
            ? Map<String, dynamic>.from(rawMeta)
            : const <String, dynamic>{},
      ),
    );
  }

  /// Items returned for the current page.
  final List<T> items;

  /// Pagination metadata.
  final PaginationMeta meta;

  /// Converts this response into JSON.
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T item) toJsonT) {
    return <String, dynamic>{
      'items': items.map<Map<String, dynamic>>(toJsonT).toList(growable: false),
      'meta': meta.toJson(),
    };
  }

  /// Creates a copy with updated values.
  PaginationResponse<T> copyWith({List<T>? items, PaginationMeta? meta}) {
    return PaginationResponse<T>(
      items: items == null ? this.items : List<T>.unmodifiable(items),
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

  /// Returns a filtered view while preserving pagination metadata.
  PaginationResponse<T> where(bool Function(T item) test) {
    return PaginationResponse<T>(
      items: List<T>.unmodifiable(items.where(test)),
      meta: meta,
    );
  }

  /// Casts every item to another compatible type.
  PaginationResponse<R> cast<R>() {
    return PaginationResponse<R>(
      items: List<R>.unmodifiable(items.cast<R>()),
      meta: meta,
    );
  }

  /// Returns the first item, or `null` if empty.
  T? get firstOrNull => isEmpty ? null : items.first;

  /// Returns the last item, or `null` if empty.
  T? get lastOrNull => isEmpty ? null : items.last;

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
  String toString() {
    return 'PaginationResponse<$T>('
        'itemCount: $itemCount, '
        'page: $currentPage/$totalPages, '
        'totalItems: $totalItems'
        ')';
  }

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
