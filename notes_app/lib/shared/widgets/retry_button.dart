import 'package:flutter/material.dart';

import 'primary_button.dart';

/// ============================================================================
/// File: retry_button.dart
/// ============================================================================
///
/// Enterprise Material 3 retry button.
///
/// A lightweight convenience wrapper around [PrimaryButton] specifically
/// designed for retry actions throughout the application.
///
/// Typical use cases:
///
/// • Network errors
/// • Offline state
/// • API failures
/// • Timeout errors
/// • Empty states
/// • Refresh operations
///
/// This widget intentionally contains no business logic. It simply applies
/// sensible defaults for retry actions while remaining fully customizable.
///
/// Example:
///
/// ```dart
/// RetryButton(
///   onPressed: _loadNotes,
/// )
/// ```
///
/// ```dart
/// RetryButton(
///   text: 'Try Again',
///   isLoading: provider.isRetrying,
///   onPressed: provider.retry,
/// )
/// ```
/// ============================================================================
@immutable
final class RetryButton extends StatelessWidget {
  /// Creates a reusable retry button.
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
  });

  /// Invoked when the retry button is pressed.
  final VoidCallback? onPressed;

  /// Button label.
  final String text;

  /// Loading label displayed while retrying.
  final String loadingText;

  /// Whether to display the loading state.
  final bool isLoading;

  /// Whether the button should occupy the available width.
  final bool isExpanded;

  /// Leading or trailing icon.
  final IconData icon;

  /// Whether the icon should appear after the text.
  final bool iconOnTrailing;

  /// Optional custom button style.
  final ButtonStyle? style;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Whether the button should receive focus automatically.
  final bool autofocus;

  /// Optional desktop/web mouse cursor.
  final MouseCursor? mouseCursor;

  /// Optional accessibility label.
  final String? semanticLabel;

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
      semanticLabel: semanticLabel ?? text,
    );
  }
}
