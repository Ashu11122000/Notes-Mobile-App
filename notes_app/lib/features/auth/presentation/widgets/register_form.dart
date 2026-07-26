import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Signature invoked when the registration form is submitted.
typedef RegisterSubmitted =
    Future<void> Function(String email, String password);

/// ============================================================================
/// File: register_form.dart
/// ============================================================================
///
/// Reusable registration form.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Collects registration credentials.
/// • Performs lightweight input validation.
/// • Handles keyboard navigation.
/// • Supports platform autofill.
/// • Delegates registration to the parent widget.
///
/// No business logic exists in this widget.
/// ============================================================================

class RegisterForm extends StatefulWidget {
  /// Creates a registration form.
  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  /// Called after successful validation.
  final RegisterSubmitted onSubmit;

  /// Whether the submit button should display a loading state.
  final bool isLoading;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  static const SizedBox _vertical16 = SizedBox(height: 16);
  static const SizedBox _vertical24 = SizedBox(height: 24);

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    FocusScope.of(context).unfocus();

    TextInput.finishAutofillContext();

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    await widget.onSubmit(email, password);

    if (!mounted) {
      return;
    }
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required.';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final String confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isLoading,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.email_outlined,
                autofillHints: const <String>[
                  AutofillHints.email,
                  AutofillHints.username,
                ],
                onFieldSubmitted: (_) {
                  _passwordFocusNode.requestFocus();
                },
                validator: _validateEmail,
              ),

              _vertical16,

              CustomTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                labelText: 'Password',
                hintText: 'Create a password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.lock_outline,
                autofillHints: const <String>[AutofillHints.newPassword],
                onFieldSubmitted: (_) {
                  _confirmPasswordFocusNode.requestFocus();
                },
                validator: _validatePassword,
              ),

              _vertical16,

              CustomTextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_reset_outlined,
                autofillHints: const <String>[AutofillHints.newPassword],
                validator: _validateConfirmPassword,
                onFieldSubmitted: (_) => _submit(),
              ),

              _vertical24,

              Semantics(
                button: true,
                child: PrimaryButton(
                  text: 'Create Account',
                  isLoading: widget.isLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
