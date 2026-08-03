import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_network_image.dart
/// ============================================================================
///
/// Enterprise Material 3 network image widget.
///
/// Lightweight theme-aware image component designed for:
///
/// - Note attachments
/// - Avatars
/// - Gallery previews
/// - Cover images
///
/// Features:
///
/// - Material 3 styling
/// - Memory optimized decoding
/// - Graceful loading state
/// - Error handling
/// - Rounded corners
/// - Accessibility support
/// - Low rendering overhead
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
    this.cacheWidth,
    this.cacheHeight,
  });

  /// Image URL.
  final String imageUrl;

  /// Image width.
  final double? width;

  /// Image height.
  final double? height;

  /// Image fit.
  final BoxFit fit;

  /// Corner radius.
  final double borderRadius;

  /// Accessibility label.
  final String? semanticLabel;

  /// Image rendering quality.
  final FilterQuality filterQuality;

  /// Target decoded image width.
  ///
  /// Reduces memory usage.
  final int? cacheWidth;

  /// Target decoded image height.
  ///
  /// Reduces memory usage.
  final int? cacheHeight;

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
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          gaplessPlayback: true,

          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return _Placeholder(
              width: width,
              height: height,
              color: theme.colorScheme.surfaceContainerLow,
            );
          },

          errorBuilder: (context, error, stackTrace) {
            return _ErrorPlaceholder(
              width: width,
              height: height,
              color: theme.colorScheme.surfaceContainerHighest,
              iconColor: theme.colorScheme.outline,
            );
          },
        ),
      ),
    );
  }
}

@immutable
final class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.width,
    required this.height,
    required this.color,
  });

  final double? width;
  final double? height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: color),
    );
  }
}

@immutable
final class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({
    required this.width,
    required this.height,
    required this.color,
    required this.iconColor,
  });

  final double? width;
  final double? height;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final smallestDimension = math.min(width ?? 80, height ?? 80);

    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: color,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: smallestDimension * 0.35,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
