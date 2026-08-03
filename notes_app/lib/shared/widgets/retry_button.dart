import 'package:flutter/material.dart';

import 'primary_button.dart';

/// ============================================================================
/// File: retry_button.dart
/// ============================================================================
///
/// Enterprise Material 3 retry button.
///
/// A lightweight convenience wrapper around [PrimaryButton] providing
/// consistent retry actions throughout the application.
///
/// Typical usage:
///
/// - Network failures
/// - Offline states
/// - API retry
/// - Timeout recovery
/// - Refresh actions
///
/// This widget contains no business logic.
@immutable
final class RetryButton extends StatelessWidget {
  const RetryButton({
    super.key,
    required this.onPressed,
    this.text = 'Retry',
    this.loadingText = 'Retrying...',
    this.isLoading = false,
    this.isExpanded = false,
    this.icon = Icons.refresh_rounded,
    this.iconOnTrailing = false,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.minimumSize,
  });

  /// Retry action.
  final VoidCallback? onPressed;

  /// Button text.
  final String text;

  /// Loading text.
  final String loadingText;

  /// Loading state.
  final bool isLoading;

  /// Full width button.
  final bool isExpanded;

  /// Optional icon.
  final IconData? icon;

  /// Icon position.
  final bool iconOnTrailing;

  /// Custom button style.
  final ButtonStyle? style;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Mouse cursor.
  final MouseCursor? mouseCursor;

  /// Accessibility label.
  final String? semanticLabel;

  /// Minimum button size.
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,

      loadingText: loadingText,

      icon: icon,

      iconOnTrailing: iconOnTrailing,

      onPressed: onPressed,

      isLoading: isLoading,

      isExpanded: isExpanded,

      style: style,

      focusNode: focusNode,

      autofocus: autofocus,

      mouseCursor: mouseCursor,

      minimumSize: minimumSize,

      semanticLabel: semanticLabel ?? (isLoading ? loadingText : text),
    );
  }
}
