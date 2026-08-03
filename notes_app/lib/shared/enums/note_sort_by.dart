/// =============================================================================
/// File: note_sort_by.dart
/// =============================================================================
///
/// Defines the supported sorting options for notes.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of Flutter widgets, repositories, networking, and persistence.
///
/// The repository or presentation layer is responsible for translating these
/// values into:
/// - API query parameters
/// - SQL ORDER BY clauses
/// - Client-side sorting algorithms
///
/// Centralizing sorting definitions provides:
/// - Strong typing
/// - Consistent UI behavior
/// - Safer persistence
/// - Easier serialization
/// - Better maintainability
enum NoteSortBy {
  /// Displays the most recently created or updated notes first.
  newest(value: 'newest', displayName: 'Newest First'),

  /// Displays the oldest notes first.
  oldest(value: 'oldest', displayName: 'Oldest First'),

  /// Sorts notes alphabetically from A to Z.
  titleAscending(value: 'title_asc', displayName: 'Title (A–Z)'),

  /// Sorts notes alphabetically from Z to A.
  titleDescending(value: 'title_desc', displayName: 'Title (Z–A)');

  /// Creates a note sorting option.
  const NoteSortBy({required this.value, required this.displayName});

  /// Stable value used for persistence and serialization.
  final String value;

  /// Human-readable label displayed in the user interface.
  ///
  /// Note: When localization is introduced, UI should provide localized
  /// strings while this enum continues to expose stable identifiers.
  final String displayName;

  /// Returns whether notes should be ordered from newest to oldest.
  bool get isNewest => this == NoteSortBy.newest;

  /// Returns whether notes should be ordered from oldest to newest.
  bool get isOldest => this == NoteSortBy.oldest;

  /// Returns whether notes should be sorted alphabetically (A–Z).
  bool get isTitleAscending => this == NoteSortBy.titleAscending;

  /// Returns whether notes should be sorted alphabetically (Z–A).
  bool get isTitleDescending => this == NoteSortBy.titleDescending;

  /// Converts a persisted value into a [NoteSortBy].
  ///
  /// Returns [NoteSortBy.newest] for `null`, empty, or unsupported values.
  static NoteSortBy fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return NoteSortBy.newest;
    }

    return values.firstWhere(
      (sortBy) => sortBy.value == normalized,
      orElse: () => NoteSortBy.newest,
    );
  }

  /// Returns whether the supplied value represents a supported sorting option.
  static bool isSupported(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return values.any((sortBy) => sortBy.value == normalized);
  }

  /// Returns the display name for a persisted sorting value.
  static String displayNameOf(String? value) => fromValue(value).displayName;

  /// All supported persisted sorting values.
  static List<String> get supportedValues =>
      values.map((sortBy) => sortBy.value).toList(growable: false);
}
