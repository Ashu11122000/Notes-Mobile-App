import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/services/logger_service.dart';

/// ============================================================================
/// File: image_picker_service.dart
/// ============================================================================
///
/// Image Picker Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Wraps the image_picker package.
/// - Picks images from gallery.
/// - Picks images from camera.
/// - Returns selected image as a File.
/// - Logs all operations.
/// - Handles exceptions gracefully.
/// - Contains no UI logic.
/// - Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
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
  // Gallery
  // ===========================================================================

  /// Opens the device gallery and returns the selected image.
  ///
  /// Returns `null` if:
  /// - the user cancels the picker
  /// - an error occurs
  Future<File?> pickFromGallery() async {
    try {
      LoggerService.info('Opening gallery...');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        LoggerService.info('Gallery picker cancelled.');
        return null;
      }

      LoggerService.info('Image selected from gallery: ${image.path}');

      return File(image.path);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to pick image from gallery.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // ===========================================================================
  // Camera
  // ===========================================================================

  /// Opens the device camera and returns the captured image.
  ///
  /// Returns `null` if:
  /// - the user cancels
  /// - an error occurs
  ///
  /// This method is not currently used by the Notes feature,
  /// but is provided for future extensibility.
  Future<File?> pickFromCamera() async {
    try {
      LoggerService.info('Opening camera...');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        LoggerService.info('Camera capture cancelled.');
        return null;
      }

      LoggerService.info('Image captured: ${image.path}');

      return File(image.path);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to capture image.',
        error: exception,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  // ===========================================================================
  // Utilities
  // ===========================================================================

  /// Returns whether the supplied file exists.
  bool exists(File? file) {
    if (file == null) {
      return false;
    }

    return file.existsSync();
  }

  /// Returns the absolute image path.
  String? getPath(File? file) {
    return file?.path;
  }

  /// Clears the selected image.
  ///
  /// The actual file is **not** deleted because it may belong to
  /// the user's gallery. The caller should simply discard its reference.
  File? removeImage() {
    LoggerService.info('Selected image removed.');

    return null;
  }
}
