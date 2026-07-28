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
/// • Controls dependency lifecycle.
/// • Provides repositories.
/// • Provides feature state management.
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
/// API
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

          create: (_) {
            return AuthRemoteDataSourceImpl();
          },
        ),

        Provider<NotesRemoteDataSource>(
          lazy: true,

          create: (_) {
            return NotesRemoteDataSourceImpl();
          },
        ),

        // =====================================================================
        // REPOSITORIES
        // =====================================================================
        Provider<AuthRepository>(
          lazy: true,

          create: (context) {
            return AuthRepositoryImpl(
              remoteDataSource: context.read<AuthRemoteDataSource>(),
            );
          },
        ),

        Provider<NotesRepository>(
          lazy: true,

          create: (context) {
            return NotesRepositoryImpl(
              remoteDataSource: context.read<NotesRemoteDataSource>(),
            );
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
          lazy: true,

          create: (_) {
            return NotificationProvider();
          },
        ),

        ChangeNotifierProvider<SettingsProvider>(
          lazy: true,

          create: (_) {
            return SettingsProvider();
          },
        ),
      ],

      child: child,
    );
  }
}
