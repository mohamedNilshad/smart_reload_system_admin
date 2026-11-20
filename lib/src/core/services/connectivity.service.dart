import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Emits `true`/`false` for actual internet reachability.
///
/// connectivity_plus alone only reports whether the device is attached to a
/// network (wifi/mobile), not whether that network can actually reach the
/// internet (e.g. connected to wifi with no internet). So on every
/// connectivity change, and on a slow background timer, this does a real
/// DNS lookup to confirm.
class ConnectivityService {
  ConnectivityService({
    Connectivity? connectivity,
    this.pollInterval = const Duration(seconds: 10),
  }) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final Duration pollInterval;

  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _timer;
  bool? _lastValue;

  /// `true` when online, `false` when offline. Emits only on change.
  Stream<bool> get onStatusChange => _controller.stream;

  Future<void> start() async {
    await _check();
    _subscription = _connectivity.onConnectivityChanged.listen((_) => _check());
    _timer = Timer.periodic(pollInterval, (_) => _check());
  }

  Future<bool> checkNow() => _check();

  Future<bool> _check() async {
    bool hasInternet;
    try {
      final adapters = await _connectivity.checkConnectivity();
      if (adapters.contains(ConnectivityResult.none) && adapters.length == 1) {
        hasInternet = false;
      } else {
        final result = await InternetAddress.lookup('one.one.one.one')
            .timeout(const Duration(seconds: 5));
        hasInternet = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      }
    } catch (_) {
      hasInternet = false;
    }

    if (hasInternet != _lastValue) {
      _lastValue = hasInternet;
      _controller.add(hasInternet);
    }
    return hasInternet;
  }

  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _controller.close();
  }
}