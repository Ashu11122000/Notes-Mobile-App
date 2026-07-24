import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:notes_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:notes_app/features/auth/data/repositories/auth_repository.dart';
import 'package:notes_app/features/auth/presentation/providers/auth_provider.dart';

/// Registers all global providers used by the application.
///
/// This widget serves as the root dependency injection container
/// for the application.
///
/// Dependency Graph
/// ---------------------------------------------------------------------------
///
/// AuthProvider
///        │
///        ▼
/// AuthRepositoryImpl
///        │
///        ▼
/// AuthRemoteDataSourceImpl
///
/// Future
/// ---------------------------------------------------------------------------
///
/// Additional providers can be registered here as the application grows:
///
/// - NotesProvider
/// - NotificationProvider
/// - SettingsProvider
class AppProviders extends StatelessWidget {
  /// Creates the root provider container.
  const AppProviders({super.key, required this.child});

  /// The widget subtree that receives all registered providers.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        // ---------------------------------------------------------------------
        // Data Sources
        // ---------------------------------------------------------------------
        Provider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSourceImpl(),
        ),

        // ---------------------------------------------------------------------
        // Repositories
        // ---------------------------------------------------------------------
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),

        // ---------------------------------------------------------------------
        // Providers
        // ---------------------------------------------------------------------
        ChangeNotifierProvider<AuthProvider>(
          create: (context) =>
              AuthProvider(repository: context.read<AuthRepository>()),
        ),
      ],
      child: child,
    );
  }
}
