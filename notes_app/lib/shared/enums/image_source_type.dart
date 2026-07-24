/// Represents the available image sources within the application.
///
/// This enum is intentionally independent of the `image_picker` package.
/// The UI or service layer is responsible for mapping these values to
/// the corresponding plugin implementation.
///
/// Example:
/// ```dart
/// switch (source) {
///   case ImageSourceType.camera:
///     // ImageSource.camera
///     break;
///   case ImageSourceType.gallery:
///     // ImageSource.gallery
///     break;
/// }
/// ```
enum ImageSourceType {
  /// Capture an image using the device camera.
  camera(value: 'camera', displayName: 'Camera'),

  /// Select an existing image from the device gallery.
  gallery(value: 'gallery', displayName: 'Gallery');

  /// Creates an image source type.
  const ImageSourceType({required this.value, required this.displayName});

  /// Value used for persistence or serialization.
  final String value;

  /// Human-readable name for the UI.
  final String displayName;

  /// Returns an [ImageSourceType] from its stored value.
  ///
  /// Defaults to [ImageSourceType.gallery] if the value is null or invalid.
  static ImageSourceType fromValue(String? value) {
    return ImageSourceType.values.firstWhere(
      (source) => source.value == value,
      orElse: () => ImageSourceType.gallery,
    );
  }
}
