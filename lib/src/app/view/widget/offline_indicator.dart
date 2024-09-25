import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result.first == ConnectivityResult.none) {
        _isDeviceConnected = false;
      } else {
        _isDeviceConnected = await InternetConnectionChecker().hasConnection;
      }
      setState(() {});
      if (_isDeviceConnected) {
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 1), () {
          _controller.reverse();
        });
      } else {
        await _controller.forward();
      }
    });
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
    // return OfflineBuilder(
    //   connectivityBuilder: (context, connectivity, child) {
    //     final connected = !connectivity.contains(ConnectivityResult.none);
    //     if (!connected) {
    //       _show = true;
    //       _controller.forward();
    //     } else if (_show) {
    //       _timer?.cancel();
    //       _timer = Timer(const Duration(seconds: 1), () {
    //         _show = false;
    //         _controller.reverse();
    //       });
    //     }
    //     return SlideTransition(
    //       position: _offsetAnimation,
    //       child: Container(
    //         padding: const EdgeInsets.all(8),
    //         color: connected ? Colors.green : Colors.red,
    //         child: Center(
    //           child: Text(
    //             connected ? 'ONLINE' : 'OFFLINE',
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    //   child: Container(),
    // );
  }
}
