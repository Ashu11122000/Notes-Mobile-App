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
/// Reusable login form.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Collects user credentials.
/// • Performs lightweight input validation.
/// • Handles keyboard navigation.
/// • Supports platform autofill.
/// • Delegates authentication to the parent widget.
///
/// No business logic exists in this widget.
/// ============================================================================

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSubmit, this.isLoading = false});

  final LoginSubmitted onSubmit;

  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const SizedBox _vertical16 = SizedBox(height: 16);
  static const SizedBox _vertical24 = SizedBox(height: 24);

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
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    FocusScope.of(context).unfocus();

    TextInput.finishAutofillContext();

    final String email = _emailController.text.trim();

    final String password = _passwordController.text;

    await widget.onSubmit(email, password);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.isLoading,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.email_outlined,
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username,
                ],
                onFieldSubmitted: (_) {
                  _passwordFocusNode.requestFocus();
                },
                validator: (value) {
                  final email = value?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Email is required.';
                  }

                  if (!_emailRegex.hasMatch(email)) {
                    return 'Please enter a valid email address.';
                  }

                  return null;
                },
              ),

              _vertical16,

              CustomTextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                validator: (value) {
                  if ((value ?? '').isEmpty) {
                    return 'Password is required.';
                  }

                  return null;
                },
              ),

              _vertical24,

              Semantics(
                button: true,
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
