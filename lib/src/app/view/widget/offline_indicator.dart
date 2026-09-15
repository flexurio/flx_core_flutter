import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class OfflineIndicator extends StatefulWidget {
  const OfflineIndicator({super.key});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator>
    with SingleTickerProviderStateMixin {
  bool _isDeviceConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then(_updateConnectivity);
    _subscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectivity,
    );
  }

  Future<void> _updateConnectivity(List<ConnectivityResult> result) async {
    final bool isConnected;
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      isConnected = false;
    } else if (kIsWeb) {
      // On Flutter Web, raw TCP sockets used by InternetConnectionChecker
      // are unsupported and fail. connectivity_plus checks navigator.onLine.
      isConnected = true;
    } else {
      isConnected = await InternetConnectionChecker().hasConnection;
    }

    if (!mounted) return;

    if (_isDeviceConnected != isConnected) {
      setState(() {
        _isDeviceConnected = isConnected;
      });
      if (_isDeviceConnected) {
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 1), () {
          if (mounted) {
            _controller.reverse();
          }
        });
      } else {
        _timer?.cancel();
        await _controller.forward();
      }
    }
  }

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    ),
  );

  @override
  void dispose() {
    _subscription.cancel();
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: _isDeviceConnected ? Colors.green : Colors.red,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isDeviceConnected)
                Container(
                  height: 16,
                  width: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              Text(
                _isDeviceConnected ? 'ONLINE' : 'OFFLINE',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
