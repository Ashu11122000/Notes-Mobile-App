import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// ignore: directives_ordering
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

// AppProviders is a class that provides application dependencies to the widget tree.
final class AppProviders extends StatelessWidget {

  // Private constructor to prevent instantiation of the class.
  const AppProviders({required this.child, super.key});

  // The child property is a widget that is passed to the AppProviders widget. It is the root widget of the application.
  final Widget child;

  // @override is a decorator that indicates that the method is used to override a method in a superclass.
  @override
  Widget build(BuildContext context) {

    // MultiProvider is a widget that provides multiple providers to its child widget.
    return MultiProvider(

      // providers: <SingleChidWidget> is a property that specifies the list of providers that should be provided to the child widget.
      providers: <SingleChildWidget>[
        
        // Provider<AuthRemoteDataSource> is a class that provides an instance of the AuthRemoteDataSource class to its child widget.
        Provider<AuthRemoteDataSource>(

          // lazy is a property that indicates whether the provider should be created lazily.
          lazy: true,

          // create: (_) is a property that specifies the function that should be used to create the provider.
          create: (_) {

            // AuthRemoteDataSourceImpl is a class that implements the AuthRemoteDataSource interface. It is used to provide an instance of the AuthRemoteDataSource class to its child widget.
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
          
          // create: (context) is a property that specifies the function that should be used to create the provider. The context parameter is used to access the widget tree and retrieve the dependencies that are required to create the provider.
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

        // ChangeNotifierProvider<AuthProvider> is a class that provides an instance of the AuthProvider class to its child widget.
        // It is used to manage the authentication state of the application.
        // It is a ChangeNotifier that notifies its listeners when the authentication state changes.
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
