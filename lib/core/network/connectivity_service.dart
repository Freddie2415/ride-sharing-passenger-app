import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = _hasConnection(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final connected = _hasConnection(results);
      if (connected != _isConnected) {
        _isConnected = connected;
        _controller.add(_isConnected);
      }
    });
  }

  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected = _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
  }
}
