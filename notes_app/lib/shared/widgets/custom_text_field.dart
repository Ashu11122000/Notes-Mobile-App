import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ============================================================================
/// File: custom_text_field.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable text field.
///
/// Optimized for:
///
/// - Authentication
/// - Notes forms
/// - Search
/// - Settings
///
/// Features:
///
/// - Material 3
/// - Password visibility
/// - Clear button
/// - Validation
/// - Autofill
/// - Accessibility
/// - Low rebuild architecture
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
    this.onClear,
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

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? labelText;

  final String? hintText;

  final String? helperText;

  final String? initialValue;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onFieldSubmitted;

  final VoidCallback? onEditingComplete;

  final VoidCallback? onTap;

  final VoidCallback? onClear;

  final IconData? prefixIcon;

  final IconData? suffixIcon;

  final int? maxLines;

  final int? minLines;

  final int? maxLength;

  final bool enabled;

  final bool readOnly;

  final Iterable<String>? autofillHints;

  final bool obscureText;

  final bool autofocus;

  final bool enableSuggestions;

  final bool autocorrect;

  final bool showClearButton;

  final TextCapitalization textCapitalization;

  final List<TextInputFormatter>? inputFormatters;

  final Color? cursorColor;

  final double cursorWidth;

  final Radius? cursorRadius;

  final TextAlign textAlign;

  final MouseCursor? mouseCursor;

  final InputDecoration? decoration;

  final String? semanticLabel;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

final class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  Widget? _suffix(BuildContext context) {
    if (widget.obscureText) {
      return IconButton(
        tooltip: _obscured ? 'Show password' : 'Hide password',
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
        onPressed: _toggleVisibility,
      );
    }

    if (widget.showClearButton && widget.controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller!,
        builder: (context, value, _) {
          if (value.text.isEmpty) {
            return widget.suffixIcon == null
                ? const SizedBox.shrink()
                : Icon(widget.suffixIcon);
          }

          return IconButton(
            tooltip: 'Clear',
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              widget.controller!.clear();

              widget.onChanged?.call('');

              widget.onClear?.call();
            },
          );
        },
      );
    }

    return widget.suffixIcon == null ? null : Icon(widget.suffixIcon);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: widget.semanticLabel ?? widget.labelText ?? widget.hintText,

      child: TextFormField(
        controller: widget.controller,

        initialValue: widget.controller == null ? widget.initialValue : null,

        focusNode: widget.focusNode,

        enabled: widget.enabled,

        readOnly: widget.readOnly,

        autofocus: widget.autofocus,

        keyboardType: widget.keyboardType,

        textInputAction: widget.textInputAction,

        textCapitalization: widget.textCapitalization,

        obscureText: _obscured,

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

              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Icon(widget.prefixIcon),

              suffixIcon: _suffix(context),
            ),
      ),
    );
  }
}
