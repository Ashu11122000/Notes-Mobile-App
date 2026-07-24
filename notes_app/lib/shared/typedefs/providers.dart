import 'package:flutter/widgets.dart';

/// Signature for creating an object managed by a Provider.
///
/// This typedef is intended for dependency injection and provider
/// registration without coupling the shared layer to a specific feature.
typedef ProviderFactory<T> = T Function();

/// Signature for lazily creating an object using BuildContext.
///
/// Useful when an object depends on other providers.
typedef ContextProviderFactory<T> = T Function(BuildContext context);

/// Signature for updating an existing provider instance.
///
/// Commonly used with ProxyProvider or ChangeNotifierProxyProvider.
typedef ProviderUpdater<T> = T Function(BuildContext context, T? previous);

/// Signature for disposing resources owned by a provider.
typedef ProviderDisposer<T> = void Function(BuildContext context, T value);
