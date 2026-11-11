import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

const String idleSessionBoxName = 'idle_session';

abstract class IdleActivityStorage {
  DateTime? readLastActivity(String key);
  void writeLastActivity(String key, DateTime timestamp);
  void clearLastActivity(String key);
}

class HiveIdleActivityStorage implements IdleActivityStorage {
  const HiveIdleActivityStorage();

  @override
  DateTime? readLastActivity(String key) {
    if (!Hive.isBoxOpen(idleSessionBoxName)) {
      return null;
    }
    final millis = Hive.box<int>(idleSessionBoxName).get(key);
    if (millis == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  @override
  void writeLastActivity(String key, DateTime timestamp) {
    if (!Hive.isBoxOpen(idleSessionBoxName)) {
      return;
    }
    unawaited(
      Hive.box<int>(idleSessionBoxName).put(
        key,
        timestamp.toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  @override
  void clearLastActivity(String key) {
    if (!Hive.isBoxOpen(idleSessionBoxName)) {
      return;
    }
    unawaited(Hive.box<int>(idleSessionBoxName).delete(key));
  }
}

class IdleApiLogoutService with WidgetsBindingObserver {
  IdleApiLogoutService({
    required Duration? Function() timeoutProvider,
    required bool Function() isAuthenticated,
    required FutureOr<void> Function() onTimeout,
    String storageKey = 'last_api_activity',
    IdleActivityStorage? storage,
    DateTime Function()? now,
  })  : _timeoutProvider = timeoutProvider,
        _isAuthenticated = isAuthenticated,
        _onTimeout = onTimeout,
        _storageKey = storageKey,
        _storage = storage ?? const HiveIdleActivityStorage(),
        _now = now ?? DateTime.now;

  final Duration? Function() _timeoutProvider;
  final bool Function() _isAuthenticated;
  final FutureOr<void> Function() _onTimeout;
  final String _storageKey;
  final IdleActivityStorage _storage;
  final DateTime Function() _now;

  Timer? _timer;
  DateTime? _lastActivityAt;
  bool _isTriggering = false;
  bool _isObservingLifecycle = false;

  Duration? get timeout {
    final value = _timeoutProvider();
    if (value == null || value <= Duration.zero) {
      return null;
    }
    return value;
  }

  bool get isEnabled => timeout != null;

  DateTime? get lastActivityAt => _lastActivityAt;

  void startObservingLifecycle() {
    if (_isObservingLifecycle) {
      return;
    }
    WidgetsBinding.instance.addObserver(this);
    _isObservingLifecycle = true;
  }

  void onAuthenticated({required bool resetTimestamp}) {
    final activeTimeout = timeout;
    if (activeTimeout == null || !_isAuthenticated()) {
      _cancelTimer();
      return;
    }

    _isTriggering = false;
    final currentNow = _now().toUtc();

    if (resetTimestamp) {
      _setLastActivity(currentNow);
      _scheduleTimer(activeTimeout);
      return;
    }

    final stored = _lastActivityAt ?? _storage.readLastActivity(_storageKey);
    if (stored == null) {
      _setLastActivity(currentNow);
      _scheduleTimer(activeTimeout);
      return;
    }

    _lastActivityAt = stored;
    final elapsed = currentNow.difference(stored);
    if (elapsed >= activeTimeout) {
      _triggerTimeout();
      return;
    }

    _scheduleTimer(activeTimeout - elapsed);
  }

  void recordActivity() {
    final activeTimeout = timeout;
    if (activeTimeout == null || !_isAuthenticated() || _isTriggering) {
      return;
    }

    _setLastActivity(_now().toUtc());
    _scheduleTimer(activeTimeout);
  }

  void checkExpiration() {
    final activeTimeout = timeout;
    if (activeTimeout == null || !_isAuthenticated() || _isTriggering) {
      _cancelTimer();
      return;
    }

    final last = _lastActivityAt ?? _storage.readLastActivity(_storageKey);
    if (last == null) {
      _setLastActivity(_now().toUtc());
      _scheduleTimer(activeTimeout);
      return;
    }

    _lastActivityAt = last;
    final elapsed = _now().toUtc().difference(last);
    if (elapsed >= activeTimeout) {
      _triggerTimeout();
      return;
    }

    _scheduleTimer(activeTimeout - elapsed);
  }

  void onLoggedOut() {
    _cancelTimer();
    _isTriggering = false;
    _lastActivityAt = null;
    _storage.clearLastActivity(_storageKey);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkExpiration();
    }
  }

  void dispose() {
    _cancelTimer();
    if (_isObservingLifecycle) {
      WidgetsBinding.instance.removeObserver(this);
      _isObservingLifecycle = false;
    }
  }

  void _setLastActivity(DateTime timestamp) {
    _lastActivityAt = timestamp;
    _storage.writeLastActivity(_storageKey, timestamp);
  }

  void _scheduleTimer(Duration delay) {
    _cancelTimer();
    _timer = Timer(delay, checkExpiration);
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _triggerTimeout() {
    if (_isTriggering) {
      return;
    }
    _isTriggering = true;
    _cancelTimer();
    _lastActivityAt = null;
    _storage.clearLastActivity(_storageKey);
    unawaited(Future<void>.sync(_onTimeout));
  }
}
