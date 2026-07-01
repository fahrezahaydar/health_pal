// test/core/utils/debouncer_test.dart
//
// Unit test untuk Debouncer — Timer-based debounce.
// Referensi: lib/core/utils/debouncer.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('executes action after delay when called once', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 50));
      var executed = false;

      debouncer(() {
        executed = true;
      });

      expect(executed, isFalse);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(executed, isTrue);
      debouncer.dispose();
    });

    test('only last action executes when called multiple times quickly', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 50));
      var lastAction = '';

      debouncer(() {
        lastAction = 'first';
      });
      debouncer(() {
        lastAction = 'second';
      });
      debouncer(() {
        lastAction = 'third';
      });

      await Future.delayed(const Duration(milliseconds: 100));
      expect(lastAction, 'third');
      debouncer.dispose();
    });

    test('dispose cancels pending timer', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 50));
      var executed = false;

      debouncer(() {
        executed = true;
      });
      debouncer.dispose();

      await Future.delayed(const Duration(milliseconds: 100));
      expect(executed, isFalse);
    });

    test('can be called again after timer fires', () async {
      final debouncer = Debouncer(const Duration(milliseconds: 30));
      var callCount = 0;

      debouncer(() {
        callCount++;
      });
      await Future.delayed(const Duration(milliseconds: 60));
      expect(callCount, 1);

      debouncer(() {
        callCount++;
      });
      await Future.delayed(const Duration(milliseconds: 60));
      expect(callCount, 2);

      debouncer.dispose();
    });
  });
}
