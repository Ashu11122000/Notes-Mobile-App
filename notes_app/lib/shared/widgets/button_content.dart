import 'package:flutter/material.dart';

/// ============================================================================
/// File: button_content.dart
/// ============================================================================
///
/// Shared internal button content renderer.
///
/// This widget centralizes the internal layout used by application buttons:
///
/// - Loading indicator
/// - Text only
/// - Icon + text
/// - Text + icon
///
/// Used by:
///
/// - PrimaryButton
/// - SecondaryButton
/// - RetryButton
///
/// Benefits:
///
/// - Removes duplicated button logic.
/// - Keeps button styling consistent.
/// - Improves maintainability.
/// - Zero runtime overhead.
/// ============================================================================

@immutable
final class ButtonContent extends StatelessWidget {
  /// Creates reusable button content.
  const ButtonContent({
    super.key,
    required this.text,
    this.loadingText,
    this.icon,
    this.isLoading = false,
    this.iconOnTrailing = false,
    this.iconSize = 20,
    this.spacing = 8,
  });

  /// Default button label.
  final String text;

  /// Label displayed during loading.
  ///
  /// Falls back to [text] when null.
  final String? loadingText;

  /// Optional button icon.
  final IconData? icon;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the icon appears after the text.
  final bool iconOnTrailing;

  /// Icon size.
  final double iconSize;

  /// Spacing between icon and text.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final label = isLoading ? loadingText ?? text : text;

    final textWidget = Flexible(
      child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
    );

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),

          SizedBox(width: spacing),

          textWidget,
        ],
      );
    }

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(icon, size: iconSize);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!iconOnTrailing) ...[iconWidget, SizedBox(width: spacing)],

        textWidget,

        if (iconOnTrailing) ...[SizedBox(width: spacing), iconWidget],
      ],
    );
  }
}
