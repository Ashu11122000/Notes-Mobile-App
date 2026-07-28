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
/// • Initializes authentication.
/// • Redirects to Login or Notes.
/// • Contains no authentication business logic.
///
/// Performance
/// ----------------------------------------------------------------------------
/// • Single initialization.
/// • No animations.
/// • No timers.
/// • Minimal widget tree.
/// • Optimized for low-memory devices.
/// ============================================================================

final class SplashScreen extends StatefulWidget {
  /// Creates the splash screen.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends State<SplashScreen> {
  static const EdgeInsets _padding = EdgeInsets.all(24);

  static const SizedBox _spacing = SizedBox(height: 48);

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized || !mounted) {
        return;
      }

      _initialized = true;

      _initialize();
    });
  }

  Future<void> _initialize() async {
    final authProvider = context.read<AuthProvider>();

    try {
      final isLoggedIn = await authProvider.initialize();

      if (!mounted) {
        return;
      }

      context.go(isLoggedIn ? AppRoutes.notes : AppRoutes.login);
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
        child: Center(
          child: Padding(
            padding: _padding,
            child: Semantics(
              container: true,
              label: 'Loading application',
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
