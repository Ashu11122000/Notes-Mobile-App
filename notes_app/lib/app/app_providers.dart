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
/// Application Dependency Injection Container
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Registers application dependencies.
/// • Provides repositories.
/// • Provides feature state managers.
/// • Controls dependency lifecycle.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
/// UI
///  ↓
/// Providers
///  ↓
/// Repositories
///  ↓
/// Data Sources
///  ↓
/// APIs
///
/// ============================================================================

final class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        // =====================================================================
        // DATA SOURCES
        // =====================================================================
        Provider<AuthRemoteDataSource>(
          lazy: true,

          create: (_) => AuthRemoteDataSourceImpl(),
        ),

        Provider<NotesRemoteDataSource>(
          lazy: true,

          create: (_) => NotesRemoteDataSourceImpl(),
        ),

        // =====================================================================
        // REPOSITORIES
        // =====================================================================
        ProxyProvider<AuthRemoteDataSource, AuthRepository>(
          lazy: true,

          update: (context, remoteDataSource, previous) {
            return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
          },
        ),

        ProxyProvider<NotesRemoteDataSource, NotesRepository>(
          lazy: true,

          update: (context, remoteDataSource, previous) {
            return NotesRepositoryImpl(remoteDataSource: remoteDataSource);
          },
        ),

        // =====================================================================
        // FEATURE PROVIDERS
        // =====================================================================
        ChangeNotifierProvider<AuthProvider>(
          lazy: true,

          create: (context) {
            return AuthProvider(repository: context.read<AuthRepository>());
          },
        ),

        ChangeNotifierProvider<NotesProvider>(
          lazy: true,

          create: (context) {
            return NotesProvider(repository: context.read<NotesRepository>());
          },
        ),

        ChangeNotifierProvider<NotificationProvider>(
          lazy: false,

          create: (_) {
            return NotificationProvider();
          },
        ),

        ChangeNotifierProvider<SettingsProvider>(
          lazy: false,

          create: (_) {
            return SettingsProvider();
          },
        ),
      ],

      child: child,
    );
  }
}
