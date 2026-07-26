/// =============================================================================
/// File: image_source_type.dart
/// =============================================================================
///
/// Defines the supported image acquisition sources within the application.
///
/// This enum intentionally belongs to the domain layer and remains completely
/// independent of Flutter plugins such as `image_picker`.
///
/// The infrastructure or service layer is responsible for mapping these values
/// to platform-specific implementations, preserving Clean Architecture
/// boundaries and improving testability.
///
/// Responsibilities:
/// - Provide a strongly typed image source.
/// - Support persistence and serialization.
/// - Drive Settings and UI selections.
/// - Decouple business logic from third-party packages.
///
/// Example:
///
/// ```dart
/// switch (source) {
///   case ImageSourceType.camera:
///     // ImageSource.camera
///     break;
///
///   case ImageSourceType.gallery:
///     // ImageSource.gallery
///     break;
/// }
/// ```
enum ImageSourceType {
  /// Capture a new image using the device camera.
  camera(value: 'camera', displayName: 'Camera'),

  /// Select an existing image from the device gallery.
  gallery(value: 'gallery', displayName: 'Gallery');

  /// Creates an image source.
  const ImageSourceType({required this.value, required this.displayName});

  /// Value used for persistence and serialization.
  ///
  /// Examples:
  /// - `camera`
  /// - `gallery`
  final String value;

  /// Human-readable label displayed in the UI.
  final String displayName;

  /// Returns whether the selected source is the device camera.
  bool get isCamera => this == ImageSourceType.camera;

  /// Returns whether the selected source is the device gallery.
  bool get isGallery => this == ImageSourceType.gallery;

  /// Converts a persisted value into an [ImageSourceType].
  ///
  /// If the supplied value is:
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default value ([ImageSourceType.gallery]) is returned.
  static ImageSourceType fromValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ImageSourceType.gallery;
    }

    final normalizedValue = value.trim().toLowerCase();

    return ImageSourceType.values.firstWhere(
      (source) => source.value == normalizedValue,
      orElse: () => ImageSourceType.gallery,
    );
  }

  /// Returns whether the provided value represents a supported image source.
  static bool isSupported(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = value.trim().toLowerCase();

    return ImageSourceType.values.any(
      (source) => source.value == normalizedValue,
    );
  }

  /// List of all supported persisted values.
  ///
  /// Useful for:
  /// - validation
  /// - serialization
  /// - analytics
  /// - Settings
  static const List<String> supportedValues = ['camera', 'gallery'];
}
