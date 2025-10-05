import 'package:connectivity_plus/connectivity_plus.dart';

class OnlineStatusChecker {
  final Connectivity _connectivity = Connectivity();

  // The connectivity_plus package has changed over time; some platforms
  // may emit a single ConnectivityResult while others may emit a
  // List<ConnectivityResult>. Handle both to stay compatible and to
  // satisfy the analyzer.
  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged
      .map((e) {
    final dynamic event = e;
    if (event is List) {
      return event.any((r) => r != ConnectivityResult.none);
    }
    return event != ConnectivityResult.none;
  });

  Future<bool> get isOnline async {
    final dynamic result = await _connectivity.checkConnectivity();
    if (result is List) {
      return result.any((r) => r != ConnectivityResult.none);
    }
    return result != ConnectivityResult.none;
  }
}