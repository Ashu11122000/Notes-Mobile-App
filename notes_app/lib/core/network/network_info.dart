import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// ============================================================================
/// File: network_info.dart
/// ============================================================================
///
/// Enterprise network information service.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Determines whether the device has network connectivity.
/// • Verifies actual internet access.
/// • Exposes connectivity change streams.
/// • Provides a lightweight abstraction over third-party packages.
/// • Contains no business logic.
///
/// This service combines:
///
/// • connectivity_plus
///   - Detects available network interfaces (Wi-Fi, Mobile, Ethernet, etc.)
///
/// • internet_connection_checker_plus
///   - Verifies real internet access.
///
/// Repositories should query this service before making remote API calls.
///
/// This service is intentionally stateless and inexpensive to create, making it
/// suitable for dependency injection.
/// ============================================================================
@immutable
final class NetworkInfo {
  NetworkInfo({
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  }) : _connectivity = connectivity ?? Connectivity(),
       _internetConnection = internetConnection ?? InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  // ===========================================================================
  // Internet Access
  // ===========================================================================

  /// Returns `true` when the device has working internet access.
  ///
  /// This checks both:
  /// - An available network interface.
  /// - Actual internet connectivity.
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      return false;
    }

    return _internetConnection.hasInternetAccess;
  }

  /// Convenience getter opposite of [isConnected].
  Future<bool> get isOffline async => !(await isConnected);

  // ===========================================================================
  // Network Interface
  // ===========================================================================

  /// Returns `true` when at least one network interface is available.
  ///
  /// This does **not** guarantee internet access.
  Future<bool> get hasNetworkInterface async {
    final results = await _connectivity.checkConnectivity();

    return !results.contains(ConnectivityResult.none);
  }

  // ===========================================================================
  // Streams
  // ===========================================================================

  /// Emits whenever the device's available network interfaces change.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Emits whenever internet availability changes.
  Stream<InternetStatus> get onInternetStatusChanged =>
      _internetConnection.onStatusChange;
}
