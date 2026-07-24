import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../data/models/login_request_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';

/// Login screen.
///
/// Responsibilities
/// ---------------------------------------------------------------------------
///
/// - Displays the authentication UI.
/// - Coordinates with [AuthProvider].
/// - Handles navigation.
/// - Displays success and error snackbars.
///
/// Business logic remains inside [AuthProvider].
class LoginScreen extends StatelessWidget {
  /// Creates a login screen.
  const LoginScreen({super.key});

  Future<void> _login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final provider = context.read<AuthProvider>();

    provider.clearError();

    try {
      await provider.login(LoginRequestModel(email: email, password: password));

      if (!context.mounted) {
        return;
      }

      CustomSnackBar.show(
        context,
        message: 'Login successful.',
        type: SnackbarType.success,
      );

      context.go(AppRoutes.notes);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      CustomSnackBar.show(
        context,
        message:
            provider.errorMessage ?? 'Unable to sign in. Please try again.',
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
          message: 'Signing in...',
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
                          title: 'Welcome Back',
                          subtitle: 'Sign in to continue to your notes.',
                        ),

                        const SizedBox(height: 32),

                        LoginForm(
                          isLoading: provider.isLoading,
                          onSubmit: (email, password) {
                            return _login(
                              context,
                              email: email,
                              password: password,
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        AuthFooter(
                          questionText: "Don't have an account?",
                          actionText: 'Create Account',
                          onPressed: () {
                            context.push('/register');
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
