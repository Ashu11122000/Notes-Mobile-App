import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../providers/auth_provider.dart';

/// ============================================================================
/// File: splash_screen.dart
/// ============================================================================
///
/// Splash Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays the application splash UI.
/// - Attempts automatic login using the stored JWT.
/// - Redirects the user to the appropriate screen.
/// - Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
/// SplashScreen
///        ↓
/// AuthProvider
///        ↓
/// AuthRepository
///        ↓
/// AuthRemoteDataSource
///        ↓
/// FastAPI
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
    final AuthProvider authProvider = context.read<AuthProvider>();

    final bool isLoggedIn = await authProvider.autoLogin();

    if (!mounted) {
      return;
    }

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.notes);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.sticky_note_2_rounded,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text('Notes App', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
