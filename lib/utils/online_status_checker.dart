import 'package:connectivity_plus/connectivity_plus.dart';

/// [OnlineStatusChecker] provides a utility to check and monitor the device's
/// internet connectivity status.
///
/// It uses the `connectivity_plus` package to listen for changes and provide
/// a stream of boolean values indicating the online status.
class OnlineStatusChecker {
  final Connectivity _connectivity = Connectivity();

  /// A stream that emits `true` if the device is online and `false` otherwise.
  ///
  /// This stream listens for connectivity changes and correctly handles the
  /// different result types from the `connectivity_plus` package.
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_parseConnectivityResult);

  /// Checks the current online status once.
  ///
  /// Returns a `Future<bool>` which completes with `true` if the device is
  /// connected to the internet and `false` otherwise.
  Future<bool> get isOnline async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return _parseConnectivityResult(connectivityResult);
  }

  /// A private helper method to interpret the result from `connectivity_plus`.
  ///
  /// It checks if the result is `ConnectivityResult.none` to determine the
  /// online status.
  bool _parseConnectivityResult(ConnectivityResult result) {
    // The device is considered offline if the result is `ConnectivityResult.none`.
    return result != ConnectivityResult.none;
  }
}
