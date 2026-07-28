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

/// ============================================================================
/// File: register_screen.dart
/// ============================================================================
///
/// Register Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the registration UI.
/// • Delegates registration to AuthProvider.
/// • Displays success and error messages.
/// • Navigates to the login screen after successful registration.
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Contains no business logic.
/// • Optimized for minimal rebuilds.
/// • Material 3 compliant.
/// • Lightweight and production-ready.
/// ============================================================================

final class RegisterScreen extends StatelessWidget {
  /// Creates a register screen.
  const RegisterScreen({super.key});

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  static const SizedBox _spacing24 = SizedBox(height: 24);
  static const SizedBox _spacing32 = SizedBox(height: 32);

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
    final bool isLoading = context.select<AuthProvider, bool>(
      (provider) => provider.isLoading,
    );

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Creating account...',
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Semantics(
              container: true,
              child: SingleChildScrollView(
                padding: _pagePadding,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const AuthHeader(
                        title: 'Create Account',
                        subtitle:
                            'Create your account to start managing your notes.',
                      ),

                      _spacing32,

                      RegisterForm(
                        isLoading: isLoading,
                        onSubmit: (email, password) {
                          return _register(
                            context,
                            email: email,
                            password: password,
                          );
                        },
                      ),

                      _spacing24,

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
      ),
    );
  }
}
