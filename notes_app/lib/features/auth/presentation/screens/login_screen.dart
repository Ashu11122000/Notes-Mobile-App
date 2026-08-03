import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../../shared/widgets/loading_overlay.dart';
import '../../data/models/login_request_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';

/// ============================================================================
/// File: login_screen.dart
/// ============================================================================
///
/// Login Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the login UI.
/// • Delegates authentication to AuthProvider.
/// • Handles navigation.
/// • Displays success and error messages.
/// • Optimized for Provider.
/// ============================================================================

final class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const EdgeInsets _pagePadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  );

  static const SizedBox _spacing24 = SizedBox(height: 24);
  static const SizedBox _spacing32 = SizedBox(height: 32);

  Future<void> _login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final AuthProvider provider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

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
      builder: (BuildContext context, AuthProvider provider, Widget? child) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          message: 'Signing in...',
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
                            title: 'Welcome Back',
                            subtitle: 'Sign in to continue to your notes.',
                          ),

                          _spacing32,

                          LoginForm(
                            isLoading: provider.isLoading,
                            onSubmit: (String email, String password) {
                              return _login(
                                context,
                                email: email,
                                password: password,
                              );
                            },
                          ),

                          _spacing24,

                          AuthFooter(
                            questionText: "Don't have an account?",
                            actionText: 'Create Account',
                            onPressed: () {
                              context.push(AppRoutes.register);
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
      },
    );
  }
}
