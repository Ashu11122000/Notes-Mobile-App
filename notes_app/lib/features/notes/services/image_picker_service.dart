import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../core/services/logger_service.dart';

/// ============================================================================
/// File: image_picker_service.dart
/// ============================================================================
///
/// Enterprise Image Picker Service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Wraps the image_picker package.
/// • Picks images from gallery.
/// • Picks images from camera.
/// • Performs lightweight validation.
/// • Converts XFile into File.
/// • Uses asynchronous file operations.
/// • Contains no UI logic.
/// • Contains no business logic.
///
/// Optimized For
/// ----------------------------------------------------------------------------
/// • Flutter Stable
/// • Android 15
/// • Low-memory devices
/// • Dell Inspiron 5590 (8 GB RAM)
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

  static const int _bytesPerMb = 1024 * 1024;

  static const Set<String> _allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'webp',
  };

  // ===========================================================================
  // Gallery
  // ===========================================================================

  /// Picks an image from the gallery.
  Future<File?> pickFromGallery() {
    return _pickImage(source: ImageSource.gallery, operation: 'Gallery');
  }

  // ===========================================================================
  // Camera
  // ===========================================================================

  /// Captures an image using the camera.
  Future<File?> pickFromCamera() {
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

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: _imageQuality,
        maxWidth: _maxWidth,
        maxHeight: _maxHeight,
      );

      if (pickedFile == null) {
        LoggerService.info('$operation image selection cancelled.');

        return null;
      }

      final File imageFile = File(pickedFile.path);

      final bool isValid = await _isValidImage(imageFile);

      if (!isValid) {
        LoggerService.warning('$operation image rejected by validation.');

        return null;
      }

      LoggerService.info('$operation image selected successfully.');

      return imageFile;
    } catch (exception, stackTrace) {
      LoggerService.error(
        '$operation image selection failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // ===========================================================================
  // Validation
  // ===========================================================================

  Future<bool> _isValidImage(File file) async {
    if (!await exists(file)) {
      return false;
    }

    if (!_hasAllowedExtension(file)) {
      return false;
    }

    if (!await _isWithinSizeLimit(file)) {
      return false;
    }

    return true;
  }

  // ===========================================================================
  // Validation Helpers
  // ===========================================================================

  Future<bool> _isWithinSizeLimit(File file) async {
    try {
      final int fileSize = await file.length();

      return fileSize <= (_maxFileSizeMb * _bytesPerMb);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unable to determine image size.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  bool _hasAllowedExtension(File file) {
    final String extension = path
        .extension(file.path)
        .replaceFirst('.', '')
        .toLowerCase();

    return _allowedExtensions.contains(extension);
  }

  // ===========================================================================
  // Utilities
  // ===========================================================================

  /// Returns true if the file exists.
  ///
  /// Uses asynchronous I/O to avoid blocking the UI thread.
  Future<bool> exists(File? file) async {
    if (file == null) {
      return false;
    }

    try {
      return await file.exists();
    } catch (_) {
      return false;
    }
  }

  /// Returns the image path.
  ///
  /// Returns null when no image is selected.
  String? getPath(File? file) {
    return file?.path;
  }

  /// Returns the image filename.
  ///
  /// Example:
  /// image.jpg
  String? getFileName(File? file) {
    if (file == null) {
      return null;
    }

    return path.basename(file.path);
  }

  /// Returns the image extension.
  ///
  /// Example:
  /// jpg
  String? getExtension(File? file) {
    if (file == null) {
      return null;
    }

    return path.extension(file.path).replaceFirst('.', '').toLowerCase();
  }

  /// Clears the selected image reference.
  ///
  /// This does NOT delete the physical image from
  /// the user's device storage.
  File? removeImage() {
    LoggerService.info('Selected image reference cleared.');

    return null;
  }
}
