import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class _FakeHttpClientAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString('{"ok": true}', 200);
  }
}

class _InMemoryIdleStorage implements IdleActivityStorage {
  final Map<String, DateTime> _data = {};

  @override
  void clearLastActivity(String key) {
    _data.remove(key);
  }

  @override
  DateTime? readLastActivity(String key) => _data[key];

  @override
  void writeLastActivity(String key, DateTime timestamp) {
    _data[key] = timestamp;
  }
}

void main() {
  group('IdleApiLogoutService', () {
    test('does nothing when timeout is null', () async {
      final storage = _InMemoryIdleStorage();
      var logoutCount = 0;

      final service = IdleApiLogoutService(
        timeoutProvider: () => null,
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
      )
        ..onAuthenticated(resetTimestamp: true)
        ..recordActivity();

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(service.isEnabled, isFalse);
      expect(logoutCount, 0);
      expect(storage.readLastActivity('last_api_activity'), isNull);
      service.dispose();
    });

    test('triggers logout after idle duration with no API activity', () async {
      final storage = _InMemoryIdleStorage();
      var currentTime = DateTime.utc(2026, 11, 11, 12);
      var logoutCount = 0;

      final service = IdleApiLogoutService(
        timeoutProvider: () => const Duration(milliseconds: 60),
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
        now: () => currentTime,
      )..onAuthenticated(resetTimestamp: true);

      expect(logoutCount, 0);

      currentTime = currentTime.add(const Duration(milliseconds: 70));
      await Future<void>.delayed(const Duration(milliseconds: 90));

      expect(logoutCount, 1);
      expect(storage.readLastActivity('last_api_activity'), isNull);
      service.dispose();
    });

    test('resets idle timer when API activity is recorded', () async {
      final storage = _InMemoryIdleStorage();
      var currentTime = DateTime.utc(2026, 11, 11, 12);
      var logoutCount = 0;

      final service = IdleApiLogoutService(
        timeoutProvider: () => const Duration(milliseconds: 90),
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
        now: () => currentTime,
      )..onAuthenticated(resetTimestamp: true);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      currentTime = currentTime.add(const Duration(milliseconds: 50));
      service.recordActivity();

      await Future<void>.delayed(const Duration(milliseconds: 55));
      currentTime = currentTime.add(const Duration(milliseconds: 55));
      expect(logoutCount, 0);

      await Future<void>.delayed(const Duration(milliseconds: 60));
      currentTime = currentTime.add(const Duration(milliseconds: 60));
      service
        ..checkExpiration()
        ..dispose();
      expect(logoutCount, 1);
    });

    test('immediately logs out on resume/restore if stored timestamp expired',
        () {
      final storage = _InMemoryIdleStorage();
      final oldTime = DateTime.utc(2026, 11, 11, 12);
      storage.writeLastActivity('last_api_activity', oldTime);

      var logoutCount = 0;
      IdleApiLogoutService(
        timeoutProvider: () => const Duration(minutes: 15),
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
        now: () => oldTime.add(const Duration(minutes: 16)),
      )
        ..onAuthenticated(resetTimestamp: false)
        ..dispose();

      expect(logoutCount, 1);
      expect(storage.readLastActivity('last_api_activity'), isNull);
    });

    test('didChangeAppLifecycleState(resumed) checks expiration', () {
      final storage = _InMemoryIdleStorage();
      var currentTime = DateTime.utc(2026, 11, 11, 12);
      var logoutCount = 0;

      final service = IdleApiLogoutService(
        timeoutProvider: () => const Duration(minutes: 15),
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
        now: () => currentTime,
      )..onAuthenticated(resetTimestamp: true);

      currentTime = currentTime.add(const Duration(minutes: 15));
      service
        ..didChangeAppLifecycleState(AppLifecycleState.resumed)
        ..dispose();

      expect(logoutCount, 1);
    });

    test('onLoggedOut cancels pending timer and clears storage', () async {
      final storage = _InMemoryIdleStorage();
      var currentTime = DateTime.utc(2026, 11, 11, 12);
      var logoutCount = 0;

      final service = IdleApiLogoutService(
        timeoutProvider: () => const Duration(milliseconds: 50),
        isAuthenticated: () => true,
        onTimeout: () => logoutCount++,
        storage: storage,
        now: () => currentTime,
      )
        ..onAuthenticated(resetTimestamp: true)
        ..onLoggedOut();

      currentTime = currentTime.add(const Duration(milliseconds: 80));
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(logoutCount, 0);
      expect(storage.readLastActivity('last_api_activity'), isNull);
      service.dispose();
    });
  });

  group('ApiActivityInterceptor', () {
    tearDown(() {
      Api.onApiActivity = null;
    });

    test('notifies Api.onApiActivity on normal request and skips when marked',
        () async {
      var activityCount = 0;
      Api.onApiActivity = () => activityCount++;

      final dio = Api.attachActivityInterceptor(Dio())
        ..httpClientAdapter = _FakeHttpClientAdapter();

      await dio.get<dynamic>('https://example.com/ping');
      expect(activityCount, 2); // onRequest + onResponse

      await dio.get<dynamic>(
        'https://example.com/silent',
        options: Options(extra: {Api.skipIdleTimerExtraKey: true}),
      );
      expect(activityCount, 2);
    });
  });
}
