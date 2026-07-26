import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/auth_provider.dart';

/// ============================================================================
/// File: splash_screen.dart
/// ============================================================================
///
/// Splash Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the application splash screen.
/// • Initializes the authentication state.
/// • Redirects to Login or Notes.
/// • Contains no authentication business logic.
///
/// Business logic remains inside [AuthProvider].
/// ============================================================================

class SplashScreen extends StatefulWidget {
  /// Creates the splash screen.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const EdgeInsets _padding = EdgeInsets.all(24);
  static const SizedBox _spacing = SizedBox(height: 48);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final AuthProvider authProvider = context.read<AuthProvider>();

    try {
      final bool isLoggedIn = await authProvider.initialize();

      if (!mounted) {
        return;
      }

      final String destination = isLoggedIn ? AppRoutes.notes : AppRoutes.login;

      context.go(destination);
    } catch (_) {
      if (!mounted) {
        return;
      }

      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Semantics(
          container: true,
          label: 'Application loading',
          child: Center(
            child: Padding(
              padding: _padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppLogo(),

                  _spacing,

                  LoadingIndicator(message: 'Loading...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
