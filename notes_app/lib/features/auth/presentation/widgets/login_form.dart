import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Signature invoked when the login form is submitted.
typedef LoginSubmitted = Future<void> Function(String email, String password);

/// ============================================================================
/// File: login_form.dart
/// ============================================================================
///
/// Reusable Login Form
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Collects user credentials.
/// • Performs lightweight validation.
/// • Supports platform autofill.
/// • Handles keyboard navigation.
/// • Delegates authentication to the parent widget.
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Contains no business logic.
/// • Optimized for minimal rebuilds.
/// • Material 3 compliant.
/// ============================================================================

final class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSubmit, this.isLoading = false});

  final LoginSubmitted onSubmit;

  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

final class _LoginFormState extends State<LoginForm> {
  static const SizedBox _spacing16 = SizedBox(height: 16);
  static const SizedBox _spacing24 = SizedBox(height: 24);

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.isLoading) {
      return;
    }

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    final focusScope = FocusScope.of(context);

    focusScope.unfocus();

    TextInput.finishAutofillContext();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await widget.onSubmit(email, password);

    if (!mounted) {
      return;
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Password is required.';
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
            mainAxisSize: MainAxisSize.min,
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

              _spacing16,

              CustomTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline,
                autofillHints: const <String>[AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                validator: _validatePassword,
              ),

              _spacing24,

              Semantics(
                button: true,
                enabled: !widget.isLoading,
                child: PrimaryButton(
                  text: 'Sign In',
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
