/// =============================================================================
/// File: image_source_type.dart
/// =============================================================================
///
/// Defines the supported image acquisition sources within the application.
///
/// This enum belongs to the domain layer and intentionally has no dependency
/// on Flutter or third-party plugins such as `image_picker`.
///
/// Infrastructure code is responsible for mapping these values to
/// platform-specific implementations, preserving Clean Architecture
/// boundaries and improving testability.
///
/// Responsibilities:
/// - Provide a strongly typed image source.
/// - Support persistence and serialization.
/// - Drive Settings and UI selections.
/// - Decouple business logic from third-party packages.
enum ImageSourceType {
  /// Capture a new image using the device camera.
  camera(value: 'camera', displayName: 'Camera'),

  /// Select an existing image from the device gallery.
  gallery(value: 'gallery', displayName: 'Gallery');

  /// Creates an image source.
  const ImageSourceType({required this.value, required this.displayName});

  /// Stable value used for persistence and serialization.
  final String value;

  /// Human-readable label displayed in the UI.
  ///
  /// Note: When localization is introduced, UI should provide localized
  /// strings while this enum continues to expose stable identifiers.
  final String displayName;

  /// Returns whether this source is the device camera.
  bool get isCamera => this == ImageSourceType.camera;

  /// Returns whether this source is the device gallery.
  bool get isGallery => this == ImageSourceType.gallery;

  /// Converts a persisted value into an [ImageSourceType].
  ///
  /// Returns [ImageSourceType.gallery] for `null`, empty, or unsupported
  /// values.
  static ImageSourceType fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return ImageSourceType.gallery;
    }

    return values.firstWhere(
      (source) => source.value == normalized,
      orElse: () => ImageSourceType.gallery,
    );
  }

  /// Returns whether a persisted value is supported.
  static bool isSupported(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return values.any((source) => source.value == normalized);
  }

  /// Returns the display name for a persisted value.
  static String displayNameOf(String? value) => fromValue(value).displayName;

  /// All supported persisted values.
  static List<String> get supportedValues =>
      values.map((source) => source.value).toList(growable: false);
}
