import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ============================================================================
/// File: custom_text_field.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable text field.
///
/// A highly reusable wrapper around [TextFormField] providing a consistent
/// appearance and behavior across the application.
///
/// Features:
///
/// • Material 3
/// • Password visibility toggle
/// • Clear button
/// • Accessibility
/// • Desktop/Web support
/// • Theme aware
/// • Input formatters
/// • Validation
/// • Autofill
/// • Read-only support
/// • Enterprise API
///
/// This widget intentionally contains no business logic and can be reused
/// throughout Authentication, Notes, Profile, Settings and future features.
/// ============================================================================

@immutable
final class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofillHints,
    this.obscureText = false,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.showClearButton = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.cursorColor,
    this.cursorWidth = 2,
    this.cursorRadius,
    this.textAlign = TextAlign.start,
    this.mouseCursor,
    this.decoration,
    this.semanticLabel,
  });

  /// Controller.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Label text.
  final String? labelText;

  /// Hint text.
  final String? hintText;

  /// Helper text.
  final String? helperText;

  /// Initial value.
  ///
  /// Ignored when [controller] is supplied.
  final String? initialValue;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Validator.
  final FormFieldValidator<String>? validator;

  /// Value changed callback.
  final ValueChanged<String>? onChanged;

  /// Submit callback.
  final ValueChanged<String>? onFieldSubmitted;

  /// Editing complete callback.
  final VoidCallback? onEditingComplete;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Prefix icon.
  final IconData? prefixIcon;

  /// Suffix icon.
  ///
  /// Ignored when [obscureText] is true.
  final IconData? suffixIcon;

  /// Maximum lines.
  final int? maxLines;

  /// Minimum lines.
  final int? minLines;

  /// Maximum length.
  final int? maxLength;

  /// Enabled.
  final bool enabled;

  /// Read only.
  final bool readOnly;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  /// Password field.
  final bool obscureText;

  /// Autofocus.
  final bool autofocus;

  /// Enable suggestions.
  final bool enableSuggestions;

  /// Enable autocorrect.
  final bool autocorrect;

  /// Show clear button.
  final bool showClearButton;

  /// Text capitalization.
  final TextCapitalization textCapitalization;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Cursor color.
  final Color? cursorColor;

  /// Cursor width.
  final double cursorWidth;

  /// Cursor radius.
  final Radius? cursorRadius;

  /// Text alignment.
  final TextAlign textAlign;

  /// Mouse cursor.
  final MouseCursor? mouseCursor;

  /// Optional decoration override.
  final InputDecoration? decoration;

  /// Accessibility label.
  final String? semanticLabel;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

final class _CustomTextFieldState extends State<CustomTextField> {
  late final ValueNotifier<bool> _obscureNotifier;

  @override
  void initState() {
    super.initState();
    _obscureNotifier = ValueNotifier<bool>(widget.obscureText);
  }

  @override
  void dispose() {
    _obscureNotifier.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    _obscureNotifier.value = !_obscureNotifier.value;
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return ValueListenableBuilder<bool>(
        valueListenable: _obscureNotifier,
        builder: (_, obscure, __) {
          return IconButton(
            tooltip: obscure ? 'Show password' : 'Hide password',
            onPressed: _togglePasswordVisibility,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          );
        },
      );
    }

    if (widget.showClearButton && widget.controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller!,
        builder: (_, value, __) {
          if (value.text.isEmpty) {
            if (widget.suffixIcon == null) {
              return const SizedBox.shrink();
            }

            return Icon(widget.suffixIcon);
          }

          return IconButton(
            tooltip: 'Clear',
            onPressed: () {
              widget.controller!.clear();
              widget.onChanged?.call('');
            },
            icon: const Icon(Icons.close_rounded),
          );
        },
      );
    }

    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: widget.semanticLabel ?? widget.labelText ?? widget.hintText,
      child: ValueListenableBuilder<bool>(
        valueListenable: _obscureNotifier,
        builder: (_, obscure, __) {
          return TextFormField(
            controller: widget.controller,
            initialValue: widget.controller == null
                ? widget.initialValue
                : null,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            obscureText: obscure,
            enableSuggestions: widget.obscureText
                ? false
                : widget.enableSuggestions,
            autocorrect: widget.obscureText ? false : widget.autocorrect,
            autofillHints: widget.autofillHints,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,
            onTap: widget.onTap,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            minLines: widget.minLines,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            cursorColor: widget.cursorColor,
            cursorWidth: widget.cursorWidth,
            cursorRadius: widget.cursorRadius,
            textAlign: widget.textAlign,
            mouseCursor: widget.mouseCursor,
            showCursor: !widget.readOnly,
            decoration:
                widget.decoration ??
                InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  helperText: widget.helperText,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon)
                      : null,
                  suffixIcon: _buildSuffixIcon(),
                ),
          );
        },
      ),
    );
  }
}
