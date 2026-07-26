import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_network_image.dart
/// ============================================================================
///
/// Enterprise Material 3 network image widget.
///
/// This widget provides a consistent, lightweight, and theme-aware way of
/// displaying images loaded from the network.
///
/// The implementation intentionally uses Flutter's built-in [Image.network]
/// to avoid introducing additional dependencies. The public API is designed so
/// that a caching implementation (for example, `cached_network_image`) can be
/// adopted in the future without affecting callers.
///
/// Features:
///
/// - Theme-aware placeholder
/// - Graceful error handling
/// - Fade-in image appearance
/// - Rounded corners
/// - Accessibility support
/// - Gapless playback
/// - Configurable filter quality
///
/// Typical use cases:
///
/// - Note attachments
/// - User avatars
/// - Gallery previews
/// - Cover images
@immutable
final class CustomNetworkImage extends StatelessWidget {
  /// Creates a reusable network image.
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.semanticLabel,
    this.filterQuality = FilterQuality.medium,
  });

  /// URL of the image.
  final String imageUrl;

  /// Image width.
  final double? width;

  /// Image height.
  final double? height;

  /// How the image should be inscribed into its bounds.
  final BoxFit fit;

  /// Corner radius.
  final double borderRadius;

  /// Accessibility label.
  final String? semanticLabel;

  /// Image filter quality.
  ///
  /// Defaults to [FilterQuality.medium] which provides a good balance between
  /// visual quality and rendering performance.
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(borderRadius);

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: radius,
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          filterQuality: filterQuality,
          gaplessPlayback: true,
          frameBuilder:
              (
                BuildContext context,
                Widget child,
                int? frame,
                bool wasSynchronouslyLoaded,
              ) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }

                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: child,
                );
              },
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
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
                return ColoredBox(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: theme.colorScheme.outline,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
        ),
      ),
    );
  }
}
