import 'package:flutter/material.dart';

/// ============================================================================
/// File: primary_button.dart
/// ============================================================================
///
/// Enterprise Material 3 primary button.
///
/// A reusable wrapper around [FilledButton] used for primary application
/// actions.
///
/// Optimized for:
///
/// - Authentication
/// - Notes CRUD
/// - Forms
/// - Settings
/// - Confirmation actions
///
/// Features:
///
/// - Material 3
/// - Theme aware
/// - Accessible
/// - Loading state
/// - Responsive
/// - Lightweight
@immutable
final class PrimaryButton extends StatelessWidget {
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
    this.minimumSize,
  });

  /// Button text.
  final String text;

  /// Button action.
  final VoidCallback? onPressed;

  /// Optional icon.
  final IconData? icon;

  /// Loading state.
  final bool isLoading;

  /// Full width button.
  final bool isExpanded;

  /// Loading text.
  final String? loadingText;

  /// Icon position.
  final bool iconOnTrailing;

  /// Custom style.
  final ButtonStyle? style;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Mouse cursor.
  final MouseCursor? mouseCursor;

  /// Accessibility label.
  final String? semanticLabel;

  /// Button minimum size.
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button = Semantics(
      button: true,

      enabled: effectiveOnPressed != null,

      label: semanticLabel ?? (isLoading ? loadingText ?? text : text),

      child: FilledButton(
        onPressed: effectiveOnPressed,

        focusNode: focusNode,

        autofocus: autofocus,

        clipBehavior: Clip.antiAlias,

        style: style ?? FilledButton.styleFrom(minimumSize: minimumSize),

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
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const SizedBox(
            width: 18,

            height: 18,

            child: CircularProgressIndicator(strokeWidth: 2),
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

        Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),

        if (iconOnTrailing) ...[const SizedBox(width: 8), iconWidget],
      ],
    );
  }
}
