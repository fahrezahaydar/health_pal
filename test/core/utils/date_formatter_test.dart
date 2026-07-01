// test/core/utils/date_formatter_test.dart
//
// Unit test untuk DateFormatter — 10+ static methods untuk date/time display.
// Referensi: lib/core/utils/date_formatter.dart

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    final testDate = DateTime(2026, 6, 15);

    test('toDayMonth formats correctly', () {
      expect(DateFormatter.toDayMonth(testDate), '15 Jun');
    });

    test('toShortDate formats correctly', () {
      expect(DateFormatter.toShortDate(testDate), '15 Jun 2026');
    });

    test('toFullDate formats correctly', () {
      expect(DateFormatter.toFullDate(testDate), '15 Juni 2026');
    });

    test('toTimeOfDayFromDateTime formats correctly', () {
      final dt = DateTime(2026, 6, 15, 9, 5);
      expect(DateFormatter.toTimeOfDayFromDateTime(dt), '09:05');
    });

    test('toTimeOfDayString formats correctly', () {
      const tod = TimeOfDay(hour: 14, minute: 30);
      expect(DateFormatter.toTimeOfDayString(tod), '14:30');
    });

    test('dayName returns correct Indonesian day names', () {
      expect(DateFormatter.dayName(1), 'Senin');
      expect(DateFormatter.dayName(6), 'Sabtu');
      expect(DateFormatter.dayName(7), 'Minggu');
    });

    group('nullable (OrDash) variants', () {
      test('toDayMonthOrDash returns formated date for non-null', () {
        expect(DateFormatter.toDayMonthOrDash(testDate), '15 Jun');
      });

      test('toDayMonthOrDash returns dash for null', () {
        expect(DateFormatter.toDayMonthOrDash(null), '\u2014');
      });

      test('toShortDateOrDash returns formated date for non-null', () {
        expect(DateFormatter.toShortDateOrDash(testDate), '15 Jun 2026');
      });

      test('toShortDateOrDash returns dash for null', () {
        expect(DateFormatter.toShortDateOrDash(null), '\u2014');
      });

      test('toFullDateOrDash returns formated date for non-null', () {
        expect(DateFormatter.toFullDateOrDash(testDate), '15 Juni 2026');
      });

      test('toFullDateOrDash returns dash for null', () {
        expect(DateFormatter.toFullDateOrDash(null), '\u2014');
      });

      test('toTimeOfDayStringOrDash returns formated time for non-null', () {
        const tod = TimeOfDay(hour: 10, minute: 0);
        expect(DateFormatter.toTimeOfDayStringOrDash(tod), '10:00');
      });

      test('toTimeOfDayStringOrDash returns dash for null', () {
        expect(DateFormatter.toTimeOfDayStringOrDash(null), '\u2014');
      });
    });
  });
}
