import 'package:flutter/widgets.dart';

/// ============================================================================
/// File: provider_typedefs.dart
/// ============================================================================
///
/// Shared callback signatures used for dependency injection and provider
/// registration.
///
/// These typedefs standardize provider-related APIs across the application,
/// improving readability and consistency while avoiding repeated function
/// signatures.
///
/// Unlike other shared typedef files, this file intentionally depends on
/// Flutter because several callbacks require a [BuildContext].
///
/// Typical usage includes:
///
/// - Dependency Injection
/// - Provider registration
/// - ProxyProvider updates
/// - Resource disposal
/// - Service initialization
///
/// This file remains independent of any specific feature and may be reused by:
///
/// - Authentication
/// - Notes
/// - Settings
/// - Notifications
/// - Analytics
/// ============================================================================

/// Creates an object managed by a provider.
///
/// The factory is typically invoked once when the provider is first inserted
/// into the widget tree.
///
/// Example:
///
/// ```dart
/// ChangeNotifierProvider(
///   create: (_) => NotesProvider(),
/// )
/// ```
typedef ProviderFactory<T> = T Function();

/// Lazily creates an object using the current [BuildContext].
///
/// This is useful when the object being created depends on other providers
/// already available in the widget tree.
///
/// Example:
///
/// ```dart
/// Provider(
///   create: (context) => Repository(
///     context.read<ApiClient>(),
///   ),
/// )
/// ```
typedef ContextProviderFactory<T> = T Function(BuildContext context);

/// Updates an existing provider instance.
///
/// Commonly used with:
///
/// - ProxyProvider
/// - ChangeNotifierProxyProvider
/// - Future dependency updates
///
/// The previous instance may be `null` during the first creation.
typedef ProviderUpdater<T> = T Function(BuildContext context, T? previous);

/// Disposes resources owned by a provider.
///
/// This callback should release any resources that require explicit cleanup,
/// such as:
///
/// - Stream subscriptions
/// - Controllers
/// - Timers
/// - Custom services
///
/// Example:
///
/// ```dart
/// dispose: (_, repository) => repository.dispose(),
/// ```
typedef ProviderDisposer<T> = void Function(BuildContext context, T value);
