/// Represents the available sorting options for notes.
///
/// This enum is shared across the application and is primarily used by the
/// Notes feature to determine how notes should be ordered.
///
/// The repository or presentation layer is responsible for mapping these
/// values to API query parameters or client-side sorting logic.
enum NoteSortBy {
  /// Sort by newest notes first.
  newest(value: 'newest', displayName: 'Newest First'),

  /// Sort by oldest notes first.
  oldest(value: 'oldest', displayName: 'Oldest First'),

  /// Sort alphabetically (A → Z).
  titleAscending(value: 'title_asc', displayName: 'Title (A–Z)'),

  /// Sort alphabetically (Z → A).
  titleDescending(value: 'title_desc', displayName: 'Title (Z–A)');

  /// Creates a note sorting option.
  const NoteSortBy({required this.value, required this.displayName});

  /// Value used for persistence or serialization.
  final String value;

  /// Human-readable name displayed in the UI.
  final String displayName;

  /// Returns a [NoteSortBy] from its stored value.
  ///
  /// Defaults to [NoteSortBy.newest] if the value is null or invalid.
  static NoteSortBy fromValue(String? value) {
    return NoteSortBy.values.firstWhere(
      (sortBy) => sortBy.value == value,
      orElse: () => NoteSortBy.newest,
    );
  }
}
