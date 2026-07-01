// test/core/network/json_converters_test.dart
//
// Unit test untuk DateOnlyJsonConverter, TimeOnlyJsonConverter, formatRupiah.
// Referensi: lib/core/network/json_converters.dart

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/network/json_converters.dart';

void main() {
  group('DateOnlyJsonConverter', () {
    final converter = const DateOnlyJsonConverter();

    group('fromJson', () {
      test('parses valid date string', () {
        final result = converter.fromJson('2026-06-15');
        expect(result, DateTime(2026, 6, 15));
      });

      test('returns null for null input', () {
        expect(converter.fromJson(null), isNull);
      });

      test('returns null for empty string', () {
        expect(converter.fromJson(''), isNull);
      });
    });

    group('toJson', () {
      test('formats DateTime to date string', () {
        final result = converter.toJson(DateTime(2026, 6, 15));
        expect(result, '2026-06-15');
      });

      test('pads month and day with zero', () {
        final result = converter.toJson(DateTime(2026, 1, 5));
        expect(result, '2026-01-05');
      });

      test('returns null for null input', () {
        expect(converter.toJson(null), isNull);
      });
    });
  });

  group('TimeOnlyJsonConverter', () {
    final converter = const TimeOnlyJsonConverter();

    group('fromJson', () {
      test('parses valid time string with seconds', () {
        final result = converter.fromJson('09:00:00');
        expect(result, const TimeOfDay(hour: 9, minute: 0));
      });

      test('parses time string without seconds', () {
        final result = converter.fromJson('14:30');
        expect(result, const TimeOfDay(hour: 14, minute: 30));
      });

      test('returns null for null input', () {
        expect(converter.fromJson(null), isNull);
      });

      test('returns null for empty string', () {
        expect(converter.fromJson(''), isNull);
      });

      test('returns null for malformed time', () {
        expect(converter.fromJson('abc'), isNull);
      });
    });

    group('toJson', () {
      test('formats TimeOfDay to time string', () {
        final result = converter.toJson(const TimeOfDay(hour: 9, minute: 0));
        expect(result, '09:00:00');
      });

      test('pads hour and minute with zero', () {
        final result = converter.toJson(const TimeOfDay(hour: 7, minute: 5));
        expect(result, '07:05:00');
      });

      test('returns null for null input', () {
        expect(converter.toJson(null), isNull);
      });
    });
  });

  group('formatRupiah', () {
    test('formats 150000 to Rp 150.000', () {
      expect(formatRupiah(150000), 'Rp 150.000');
    });

    test('formats small number correctly', () {
      expect(formatRupiah(5000), 'Rp 5.000');
    });

    test('formats 0 correctly', () {
      expect(formatRupiah(0), 'Rp 0');
    });

    test('formats large number with grouping', () {
      expect(formatRupiah(1000000), 'Rp 1.000.000');
    });

    test('ignores decimal part', () {
      expect(formatRupiah(150000.75), 'Rp 150.000');
    });
  });
}
