import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: pagination_meta.dart
/// ============================================================================
///
/// Represents pagination metadata returned by paginated API endpoints.
///
/// This model is intentionally generic and reusable across any feature that
/// supports pagination, including:
///
/// - Notes
/// - Tasks
/// - Users
/// - Analytics
/// - Notifications
///
/// It contains only pagination metadata and is independent of any specific
/// backend implementation.
///
/// Example JSON:
///
/// ```json
/// {
///   "page": 1,
///   "size": 10,
///   "total": 125,
///   "pages": 13
/// }
/// ```
@immutable
final class PaginationMeta {
  /// Creates immutable pagination metadata.
  const PaginationMeta({
    required this.page,
    required this.size,
    required this.total,
    required this.pages,
  });

  /// Creates an empty pagination metadata instance.
  const PaginationMeta.empty() : page = 1, size = 10, total = 0, pages = 0;

  /// Creates pagination metadata from JSON.
  ///
  /// Invalid or missing values are normalized to sensible defaults.
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    final page = math.max(1, (json['page'] as num?)?.toInt() ?? 1);
    final size = math.max(1, (json['size'] as num?)?.toInt() ?? 10);
    final total = math.max(0, (json['total'] as num?)?.toInt() ?? 0);

    final rawPages = (json['pages'] as num?)?.toInt();

    final pages = rawPages != null && rawPages > 0
        ? rawPages
        : (total == 0 ? 0 : (total / size).ceil());

    return PaginationMeta(page: page, size: size, total: total, pages: pages);
  }

  /// Current page (1-based).
  final int page;

  /// Number of requested items per page.
  final int size;

  /// Total number of available records.
  final int total;

  /// Total number of available pages.
  final int pages;

  /// Converts this object into JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'size': size,
    'total': total,
    'pages': pages,
  };

  /// Creates a copy with updated values.
  PaginationMeta copyWith({int? page, int? size, int? total, int? pages}) {
    return PaginationMeta(
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      pages: pages ?? this.pages,
    );
  }

  /// Whether another page exists.
  bool get hasNextPage => page < pages;

  /// Whether a previous page exists.
  bool get hasPreviousPage => page > 1;

  /// Whether this is the first page.
  bool get isFirstPage => page == 1;

  /// Whether this is the last page.
  bool get isLastPage => pages == 0 || page >= pages;

  /// Whether the paginated collection contains no records.
  bool get isEmpty => total == 0;

  /// Whether the paginated collection contains at least one record.
  bool get isNotEmpty => !isEmpty;

  /// Number of items skipped before the current page.
  int get skippedItems => (page - 1) * size;

  /// Number of the next page.
  ///
  /// Returns the current page if already on the last page.
  int get nextPage => hasNextPage ? page + 1 : page;

  /// Number of the previous page.
  ///
  /// Returns the current page if already on the first page.
  int get previousPage => hasPreviousPage ? page - 1 : page;

  /// Number of items loaded up to and including the current page.
  ///
  /// Never exceeds [total].
  int get loadedItems => math.min(page * size, total);

  /// Number of items remaining after the current page.
  ///
  /// Never becomes negative.
  int get remainingItems => math.max(0, total - loadedItems);

  @override
  String toString() {
    return 'PaginationMeta('
        'page: $page, '
        'pages: $pages, '
        'size: $size, '
        'total: $total'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginationMeta &&
            page == other.page &&
            size == other.size &&
            total == other.total &&
            pages == other.pages;
  }

  @override
  int get hashCode => Object.hash(page, size, total, pages);
}
