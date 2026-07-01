// test/core/enums/booking_status_test.dart
//
// Unit test untuk BookingStatus enum.
// BUG regression: Sprint 2 A5 — @JsonValue + safe fromJson (bukan firstWhere).
// Referensi: lib/core/enums/booking_status.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/booking_status.dart';

void main() {
  group('BookingStatus.fromJson', () {
    test('returns pending for "pending"', () {
      expect(BookingStatus.fromJson('pending'), BookingStatus.pending);
    });

    test('returns upcoming for "upcoming"', () {
      expect(BookingStatus.fromJson('upcoming'), BookingStatus.upcoming);
    });

    test('returns completed for "completed"', () {
      expect(BookingStatus.fromJson('completed'), BookingStatus.completed);
    });

    test('returns cancelled for "cancelled"', () {
      expect(BookingStatus.fromJson('cancelled'), BookingStatus.cancelled);
    });

    test('returns pending (fallback) for null input', () {
      expect(BookingStatus.fromJson(null), BookingStatus.pending);
    });

    test('returns pending (fallback) for unknown value', () {
      expect(BookingStatus.fromJson('rescheduled'), BookingStatus.pending);
    });

    test('returns pending (fallback) for uppercase value (case-sensitive)', () {
      expect(BookingStatus.fromJson('PENDING'), BookingStatus.pending);
    });

    test('returns pending (fallback) for empty string', () {
      expect(BookingStatus.fromJson(''), BookingStatus.pending);
    });
  });

  group('BookingStatus.values', () {
    test('has exactly 4 status values', () {
      expect(BookingStatus.values.length, 4);
    });

    test('contains all expected values', () {
      expect(BookingStatus.values, containsAll([
        BookingStatus.pending,
        BookingStatus.upcoming,
        BookingStatus.completed,
        BookingStatus.cancelled,
      ]));
    });
  });
}
