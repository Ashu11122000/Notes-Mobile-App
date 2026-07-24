import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Signature invoked when the registration form is submitted.
typedef RegisterSubmitted =
    Future<void> Function(String email, String password);

/// A reusable registration form.
///
/// This widget is responsible only for collecting and validating the
/// user's registration details.
///
/// Business logic such as authentication, navigation, and displaying
/// snackbars should be handled by the parent screen.
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
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    // Notify the platform that the autofill session has completed.
    TextInput.finishAutofillContext();

    await widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    const pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

    if (!RegExp(pattern).hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
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
              validator: _validateEmail,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Create a password',
              obscureText: true,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.lock_outline,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validatePassword,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              obscureText: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock_reset_outlined,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validateConfirmPassword,
              onFieldSubmitted: (_) => _submit(),
            ),

            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Create Account',
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
