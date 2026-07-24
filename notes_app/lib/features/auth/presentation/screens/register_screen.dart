import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../data/models/register_request_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';

/// Register screen.
///
/// Responsibilities
/// ---------------------------------------------------------------------------
///
/// - Displays the registration UI.
/// - Coordinates with [AuthProvider].
/// - Shows success and error snackbars.
/// - Navigates back to Login after successful registration.
///
/// Business logic remains inside [AuthProvider].
class RegisterScreen extends StatelessWidget {
  /// Creates a register screen.
  const RegisterScreen({super.key});

  Future<void> _register(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final provider = context.read<AuthProvider>();

    provider.clearError();

    try {
      await provider.register(
        RegisterRequestModel(email: email, password: password),
      );

      if (!context.mounted) {
        return;
      }

      CustomSnackBar.show(
        context,
        message: 'Account created successfully. Please sign in.',
        type: SnackbarType.success,
      );

      context.go(AppRoutes.login);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      CustomSnackBar.show(
        context,
        message:
            provider.errorMessage ??
            'Unable to create your account. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          message: 'Creating account...',
          child: Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeader(
                          title: 'Create Account',
                          subtitle:
                              'Create your account to start managing your notes.',
                        ),

                        const SizedBox(height: 32),

                        RegisterForm(
                          isLoading: provider.isLoading,
                          onSubmit: (email, password) {
                            return _register(
                              context,
                              email: email,
                              password: password,
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        AuthFooter(
                          questionText: 'Already have an account?',
                          actionText: 'Sign In',
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
