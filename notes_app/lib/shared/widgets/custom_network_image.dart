import 'package:flutter/material.dart';

/// A reusable network image widget.
///
/// This widget provides a consistent way of displaying images loaded from
/// the network with built-in loading and error handling.
///
/// The implementation intentionally uses Flutter's built-in [Image.network]
/// so that a caching package can be introduced later without changing
/// the widget's public API.
///
/// Example:
/// ```dart
/// CustomNetworkImage(
///   imageUrl: note.imageUrl,
/// )
/// ```
class CustomNetworkImage extends StatelessWidget {
  /// Creates a reusable network image.
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
  });

  /// URL of the image.
  final String imageUrl;

  /// Width of the image.
  final double? width;

  /// Height of the image.
  final double? height;

  /// How the image should be inscribed into its space.
  final BoxFit fit;

  /// Corner radius.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              }

              return SizedBox(
                width: width,
                height: height,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_rounded,
                  color: Theme.of(context).colorScheme.outline,
                  size: 40,
                ),
              );
            },
      ),
    );
  }
}
