import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/services/logger_service.dart';

/// ============================================================================
/// File: image_picker_service.dart
/// ============================================================================
///
/// Image Picker Service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Wraps the image_picker package.
/// • Picks images from gallery.
/// • Picks images from camera.
/// • Converts XFile into File.
/// • Handles picker exceptions.
/// • Provides image validation helpers.
/// • Contains no UI logic.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesProvider
///     ↓
/// ImagePickerService
///     ↓
/// image_picker
///
/// ============================================================================

final class ImagePickerService {
  ImagePickerService({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  // ===========================================================================
  // Configuration
  // ===========================================================================

  static const int _imageQuality = 85;

  static const double _maxWidth = 1920;

  static const double _maxHeight = 1080;

  static const int _maxFileSizeMb = 10;

  static const List<String> _allowedExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // ===========================================================================
  // Gallery
  // ===========================================================================

  /// Picks an image from the device gallery.
  ///
  /// Returns:
  /// - Selected image file
  /// - null when cancelled or failed
  Future<File?> pickFromGallery() async {
    return _pickImage(source: ImageSource.gallery, operation: 'Gallery');
  }

  // ===========================================================================
  // Camera
  // ===========================================================================

  /// Captures an image using the camera.
  ///
  /// Returns:
  /// - Captured image file
  /// - null when cancelled or failed
  Future<File?> pickFromCamera() async {
    return _pickImage(source: ImageSource.camera, operation: 'Camera');
  }

  // ===========================================================================
  // Internal Picker
  // ===========================================================================

  Future<File?> _pickImage({
    required ImageSource source,
    required String operation,
  }) async {
    try {
      LoggerService.info('$operation image picker opened.');

      final XFile? pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: _imageQuality,
        maxWidth: _maxWidth,
        maxHeight: _maxHeight,
      );

      if (pickedImage == null) {
        LoggerService.info('$operation image selection cancelled.');

        return null;
      }

      final File file = File(pickedImage.path);

      if (!_isValidImage(file)) {
        LoggerService.warning('Invalid image selected.');

        return null;
      }

      LoggerService.info('$operation image selected successfully.');

      return file;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed during $operation image selection.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // ===========================================================================
  // Validation
  // ===========================================================================

  /// Checks whether the image is acceptable.
  bool _isValidImage(File file) {
    if (!exists(file)) {
      return false;
    }

    if (!_isAllowedExtension(file)) {
      return false;
    }

    if (!_isWithinSizeLimit(file)) {
      return false;
    }

    return true;
  }

  bool _isAllowedExtension(File file) {
    final String extension = file.path.split('.').last.toLowerCase();

    return _allowedExtensions.contains(extension);
  }

  bool _isWithinSizeLimit(File file) {
    final int sizeInBytes = file.lengthSync();

    final double sizeInMb = sizeInBytes / (1024 * 1024);

    return sizeInMb <= _maxFileSizeMb;
  }

  // ===========================================================================
  // Utilities
  // ===========================================================================

  /// Checks whether a file exists.
  bool exists(File? file) {
    return file != null && file.existsSync();
  }

  /// Returns the file path.
  String? getPath(File? file) {
    return file?.path;
  }

  /// Clears selected image reference.
  ///
  /// Does not delete the physical file because
  /// it may belong to the user's device storage.
  File? removeImage() {
    LoggerService.info('Selected image reference cleared.');

    return null;
  }
}
