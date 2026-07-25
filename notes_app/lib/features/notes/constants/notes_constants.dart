/// ============================================================================
/// File: notes_constants.dart
/// ============================================================================
///
/// Notes feature constants.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Centralize Notes-specific configuration.
/// - Avoid magic numbers and hardcoded strings.
/// - Provide reusable values across the Notes feature.
///
/// Notes
/// ----------------------------------------------------------------------------
/// API endpoints belong in [ApiConstants].
/// This file contains only Notes feature constants.
///
/// ============================================================================

final class NotesConstants {
  const NotesConstants._();

  // ===========================================================================
  // Pagination
  // ===========================================================================

  /// Default number of notes per page.
  static const int defaultPageSize = 10;

  /// Initial page number.
  static const int initialPage = 1;

  // ===========================================================================
  // Validation
  // ===========================================================================

  /// Minimum title length.
  static const int minTitleLength = 1;

  /// Maximum title length.
  static const int maxTitleLength = 255;

  /// Maximum content length.
  ///
  /// Matches the current backend implementation where the content is stored
  /// in a SQLAlchemy String column. Adjust if the backend introduces a limit.
  static const int maxContentLength = 5000;

  // ===========================================================================
  // UI
  // ===========================================================================

  /// Scroll offset (in pixels) before loading the next page.
  static const double paginationThreshold = 200.0;

  /// Default animation duration.
  static const Duration animationDuration = Duration(milliseconds: 300);

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Debounce duration for search input.
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // ===========================================================================
  // Hero Tags
  // ===========================================================================

  /// Hero tag for the Notes floating action button.
  static const String notesFabHeroTag = 'notes_fab';

  // ===========================================================================
  // Route Arguments
  // ===========================================================================

  /// Route argument key for passing a note identifier.
  static const String noteIdArgument = 'noteId';
}
