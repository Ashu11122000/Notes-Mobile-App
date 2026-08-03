import 'package:flutter/material.dart';

import 'button_content.dart';

/// ============================================================================
/// File: secondary_button.dart
/// ============================================================================
///
/// Enterprise Material 3 secondary button.
///
/// Wrapper around [OutlinedButton] providing a consistent secondary action
/// button throughout the application.
///
/// Used for:
///
/// - Cancel actions
/// - Register actions
/// - Back navigation
/// - Optional actions
///
/// Features:
///
/// - Material 3
/// - Accessible
/// - Loading state
/// - Responsive
/// - Lightweight
@immutable
final class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.loadingText,
    this.iconOnTrailing = false,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.minimumSize,
  });

  /// Button label.
  final String text;

  /// Button callback.
  final VoidCallback? onPressed;

  /// Optional icon.
  final IconData? icon;

  /// Loading state.
  final bool isLoading;

  /// Expand width.
  final bool isExpanded;

  /// Loading label.
  final String? loadingText;

  /// Icon position.
  final bool iconOnTrailing;

  /// Button style.
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
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button = Semantics(
      button: true,

      enabled: effectiveOnPressed != null,

      label: semanticLabel ?? (isLoading ? loadingText ?? text : text),

      child: OutlinedButton(
        onPressed: effectiveOnPressed,

        style: style ?? OutlinedButton.styleFrom(minimumSize: minimumSize),

        focusNode: focusNode,

        autofocus: autofocus,

        clipBehavior: Clip.antiAlias,

        child: ButtonContent(
          text: text,

          loadingText: loadingText,

          icon: icon,

          isLoading: isLoading,

          iconOnTrailing: iconOnTrailing,
        ),
      ),
    );

    if (mouseCursor != null) {
      button = MouseRegion(cursor: mouseCursor!, child: button);
    }

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
