// ignore_for_file: duplicate_import

import 'package:flutter/material.dart';
import 'package:notes_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:notes_app/features/auth/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

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
/// - NotesProvider
/// - NotificationProvider
/// - SettingsProvider
class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

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
          create: (BuildContext context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),

        // ---------------------------------------------------------------------
        // Providers
        // ---------------------------------------------------------------------
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) =>
              AuthProvider(repository: context.read<AuthRepository>()),
        ),
      ],
      child: child,
    );
  }
}
