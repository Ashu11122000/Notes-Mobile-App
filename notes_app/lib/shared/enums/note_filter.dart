/// =============================================================================
/// File: note_filter.dart
/// =============================================================================
///
/// Defines the filtering options available for the Notes feature.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of Flutter widgets, networking, and persistence implementations.
///
/// The selected filter may be applied:
/// - Server-side through API query parameters.
/// - Client-side after fetching note data.
///
/// Centralizing filter definitions provides:
/// - Strong typing
/// - Safer persistence
/// - Easier serialization
/// - Consistent UI behavior
/// - Better maintainability
enum NoteFilter {
  /// Displays every available note.
  all(value: 'all', displayName: 'All'),

  /// Displays notes matching the current search query.
  ///
  /// The search implementation may be performed either locally or by
  /// the backend API.
  search(value: 'search', displayName: 'Search');

  const NoteFilter({required this.value, required this.displayName});

  /// Stable value used for persistence and serialization.
  final String value;

  /// Human-readable label displayed in the UI.
  ///
  /// Note: When localization is introduced, UI should provide localized
  /// strings while this enum continues to expose stable identifiers.
  final String displayName;

  /// Returns whether this filter displays every note.
  bool get isAll => this == NoteFilter.all;

  /// Returns whether this filter represents a search operation.
  bool get isSearch => this == NoteFilter.search;

  /// Converts a persisted value into a [NoteFilter].
  ///
  /// Returns [NoteFilter.all] for `null`, empty, or unsupported values.
  static NoteFilter fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return NoteFilter.all;
    }

    return values.firstWhere(
      (filter) => filter.value == normalized,
      orElse: () => NoteFilter.all,
    );
  }

  /// Returns whether the supplied value represents a supported filter.
  static bool isSupported(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return values.any((filter) => filter.value == normalized);
  }

  /// Returns the display name for a persisted filter value.
  static String displayNameOf(String? value) => fromValue(value).displayName;

  /// All supported persisted values.
  static List<String> get supportedValues =>
      values.map((filter) => filter.value).toList(growable: false);
}
