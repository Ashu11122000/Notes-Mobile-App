import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Provides information about the device's network connectivity.
///
/// This class combines:
/// - connectivity_plus (network type)
/// - internet_connection_checker_plus (actual internet access)
///
/// Repositories should use this service before making remote API calls.
final class NetworkInfo {
  NetworkInfo({
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  }) : _connectivity = connectivity ?? Connectivity(),
       _internetConnection = internetConnection ?? InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  /// Returns `true` when the device has an active internet connection.
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    return _internetConnection.hasInternetAccess;
  }

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
