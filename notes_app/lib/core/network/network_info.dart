import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// =============================================================================
/// File: network_info.dart
/// =============================================================================
///
/// Enterprise network information service.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Detects available network interfaces.
/// • Verifies actual internet connectivity.
/// • Exposes connectivity streams.
/// • Provides a lightweight abstraction over networking packages.
/// • Contains no business logic.
///
/// Notes
/// -----------------------------------------------------------------------------
///
/// connectivity_plus
///   • Reports available network interfaces.
///   • Does NOT guarantee internet access.
///
/// internet_connection_checker_plus
///   • Verifies real internet connectivity.
///
/// Repositories should check [isConnected] before performing remote API calls.
///
/// =============================================================================
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
  // Internet Connectivity
  // ===========================================================================

  /// Returns true when:
  ///
  /// • A network interface exists.
  /// • Internet is actually reachable.
  Future<bool> get isConnected async {
    if (!await hasNetworkInterface) {
      return false;
    }

    return _internetConnection.hasInternetAccess;
  }

  /// Returns true when internet is unavailable.
  Future<bool> get isOffline async => !(await isConnected);

  // ===========================================================================
  // Network Interface
  // ===========================================================================

  /// Returns true if at least one network interface exists.
  ///
  /// This does not guarantee internet access.
  Future<bool> get hasNetworkInterface async {
    final List<ConnectivityResult> results = await _connectivity
        .checkConnectivity();

    return !results.contains(ConnectivityResult.none);
  }

  // ===========================================================================
  // Streams
  // ===========================================================================

  /// Emits whenever available network interfaces change.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Emits whenever internet availability changes.
  Stream<InternetStatus> get onInternetStatusChanged =>
      _internetConnection.onStatusChange;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  /// Reserved for future implementations.
  ///
  /// Current dependencies do not require explicit disposal, but exposing this
  /// method keeps the service easy to extend without changing consumers.
  @mustCallSuper
  void dispose() {}
}
