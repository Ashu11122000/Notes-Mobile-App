import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/auth_provider.dart';

/// ============================================================================
/// Splash Screen
/// ============================================================================
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays the application splash screen.
/// - Attempts automatic login.
/// - Redirects to Login or Notes.
/// - Contains no authentication business logic.
/// ============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final authProvider = context.read<AuthProvider>();

    final isLoggedIn = await authProvider.autoLogin();

    if (!mounted) {
      return;
    }

    if (isLoggedIn) {
      context.go(AppRoutes.notes);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(),

                SizedBox(height: 48),

                LoadingIndicator(message: 'Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
