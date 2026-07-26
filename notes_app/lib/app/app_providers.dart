import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:notes_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:notes_app/features/auth/data/repositories/auth_repository.dart';
import 'package:notes_app/features/auth/presentation/providers/auth_provider.dart';

import 'package:notes_app/features/notes/data/datasources/notes_remote_data_source.dart';
import 'package:notes_app/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes_app/features/notes/presentation/providers/notes_provider.dart';

import 'package:notes_app/features/notifications/presentation/providers/notification_provider.dart';

import 'package:notes_app/features/settings/presentation/providers/settings_provider.dart';

/// ============================================================================
/// File: app_providers.dart
/// ============================================================================
///
/// Registers all application-wide dependencies.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Register remote data sources.
/// - Register repositories.
/// - Register ChangeNotifier providers.
/// - Serve as the application's dependency injection container.
///
/// ============================================================================

final class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  /// Widget subtree that receives all registered providers.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        // =====================================================================
        // Remote Data Sources
        // =====================================================================
        Provider<AuthRemoteDataSource>(
          create: (_) => AuthRemoteDataSourceImpl(),
        ),

        Provider<NotesRemoteDataSource>(
          create: (_) => NotesRemoteDataSourceImpl(),
        ),

        // =====================================================================
        // Repositories
        // =====================================================================
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
          ),
        ),

        Provider<NotesRepository>(
          create: (context) => NotesRepositoryImpl(
            remoteDataSource: context.read<NotesRemoteDataSource>(),
          ),
        ),

        // =====================================================================
        // ChangeNotifier Providers
        // =====================================================================
        ChangeNotifierProvider<AuthProvider>(
          create: (context) =>
              AuthProvider(repository: context.read<AuthRepository>()),
        ),

        ChangeNotifierProvider<NotesProvider>(
          create: (context) =>
              NotesProvider(repository: context.read<NotesRepository>()),
        ),

        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),

        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: child,
    );
  }
}
