import 'package:flutter/material.dart';

/// A reusable Material 3 text field.
///
/// This widget wraps Flutter's [TextFormField] and provides a consistent
/// appearance throughout the application.
///
/// It also manages password visibility internally when [obscureText]
/// is enabled.
class CustomTextField extends StatefulWidget {
  /// Creates a reusable text field.
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
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.autofillHints,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Label displayed above the field.
  final String? labelText;

  /// Placeholder text.
  final String? hintText;

  /// Helper text displayed below the field.
  final String? helperText;

  /// Initial value.
  ///
  /// Ignored when [controller] is provided.
  final String? initialValue;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Validation callback.
  final String? Function(String?)? validator;

  /// Called whenever the value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field.
  final ValueChanged<String>? onFieldSubmitted;

  /// Optional leading icon.
  final IconData? prefixIcon;

  /// Optional trailing icon.
  ///
  /// Ignored when [obscureText] is true.
  final IconData? suffixIcon;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read only.
  final bool readOnly;

  /// Autofill hints.
  final Iterable<String>? autofillHints;

  /// Whether this is a password field.
  final bool obscureText;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      obscureText: _obscureText,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      minLines: widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : widget.suffixIcon != null
            ? Icon(widget.suffixIcon)
            : null,
      ),
    );
  }
}
