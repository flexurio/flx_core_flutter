import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 500)});

  final Duration duration;
  Timer? _timer;

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
