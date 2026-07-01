// test/core/utils/retry_test.dart
//
// Unit test untuk withRetry<T> — exponential backoff retry.
// Referensi: lib/core/utils/retry.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/utils/retry.dart';

void main() {
  group('withRetry', () {
    test('returns result on first successful attempt', () async {
      final result = await withRetry(() async => 'success');
      expect(result, 'success');
    });

    test('retries on SocketException and succeeds', () async {
      var attempts = 0;
      final result = await withRetry(() async {
        attempts++;
        if (attempts < 2) throw const SocketException('no internet');
        return 'ok';
      }, maxRetries: 2);
      expect(result, 'ok');
      expect(attempts, 2);
    });

    test('retries on TimeoutException and succeeds', () async {
      var attempts = 0;
      final result = await withRetry(() async {
        attempts++;
        if (attempts < 2) throw TimeoutException('too slow');
        return 'ok';
      }, maxRetries: 2);
      expect(result, 'ok');
      expect(attempts, 2);
    });

    test('rethrows SocketException after max retries', () async {
      var attempts = 0;
      await expectLater(
        withRetry(() async {
          attempts++;
          throw const SocketException('persistent');
        }, maxRetries: 2),
        throwsA(isA<SocketException>()),
      );
      expect(attempts, 3);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('rethrows non-retryable error immediately (no retry)', () async {
      var attempts = 0;
      await expectLater(
        withRetry(() async {
          attempts++;
          throw ArgumentError('non-retryable');
        }, maxRetries: 2),
        throwsA(isA<ArgumentError>()),
      );
      expect(attempts, 1);
    });
  });
}
