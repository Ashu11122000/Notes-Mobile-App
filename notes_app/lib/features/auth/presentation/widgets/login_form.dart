import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Signature invoked when the login form is submitted.
typedef LoginSubmitted = Future<void> Function(String email, String password);

/// A reusable login form.
///
/// This widget is responsible only for collecting and validating
/// the user's credentials.
///
/// Business logic such as authentication, navigation, and displaying
/// snackbars should be handled by the parent screen.
class LoginForm extends StatefulWidget {
  /// Creates a login form.
  const LoginForm({super.key, required this.onSubmit, this.isLoading = false});

  /// Called after successful validation.
  final LoginSubmitted onSubmit;

  /// Whether the submit button should display a loading state.
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    await widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.email_outlined,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required.';
              }

              final email = value.trim();

              const pattern =
                  r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

              if (!RegExp(pattern).hasMatch(email)) {
                return 'Please enter a valid email address.';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_outline,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required.';
              }

              return null;
            },
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: 'Sign In',
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
