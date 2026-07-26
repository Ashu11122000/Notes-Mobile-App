import 'package:flutter/material.dart';

/// ============================================================================
/// File: primary_button.dart
/// ============================================================================
///
/// Enterprise Material 3 primary button.
///
/// A reusable wrapper around [FilledButton] that provides a consistent primary
/// action button throughout the application.
///
/// Typical use cases:
///
/// • Login
/// • Register
/// • Save Note
/// • Update Note
/// • Delete Note
/// • Retry
/// • Refresh
/// • Logout
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Accessible
/// • Loading state
/// • Responsive
/// • Desktop/Web friendly
/// • Lightweight
/// • Reusable
///
/// Example:
///
/// ```dart
/// PrimaryButton(
///   text: 'Sign In',
///   onPressed: _login,
/// )
/// ```
///
/// ```dart
/// PrimaryButton(
///   text: 'Save',
///   icon: Icons.save_rounded,
///   onPressed: save,
/// )
/// ```
/// ============================================================================
@immutable
final class PrimaryButton extends StatelessWidget {
  /// Creates an enterprise primary button.
  const PrimaryButton({
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
  });

  /// Button label.
  final String text;

  /// Invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional leading/trailing icon.
  final IconData? icon;

  /// Whether to display the loading state.
  final bool isLoading;

  /// Whether the button should occupy the available width.
  final bool isExpanded;

  /// Optional loading label.
  ///
  /// When null, [text] is displayed while loading.
  final String? loadingText;

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
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button = Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: semanticLabel ?? text,
      child: FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: Clip.antiAlias,
        child: _ButtonContent(
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

/// Internal reusable button content.
///
/// Displays one of the following:
///
/// • Loading indicator
/// • Icon + text
/// • Text + icon
/// • Text only
@immutable
final class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.loadingText,
    required this.icon,
    required this.isLoading,
    required this.iconOnTrailing,
  });

  final String text;
  final String? loadingText;
  final IconData? icon;
  final bool isLoading;
  final bool iconOnTrailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(loadingText ?? text),
        ],
      );
    }

    if (icon == null) {
      return Text(text);
    }

    final iconWidget = Icon(icon, size: 20);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!iconOnTrailing) ...[iconWidget, const SizedBox(width: 8)],

        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge,
          ),
        ),

        if (iconOnTrailing) ...[const SizedBox(width: 8), iconWidget],
      ],
    );
  }
}
