// test/core/utils/validators_test.dart
//
// Unit test untuk Validators — 5 static validation methods.
// Referensi: lib/core/utils/validators.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
    });

    test('returns error for null input', () {
      expect(Validators.email(null), 'Email is required');
    });

    test('returns error for empty input', () {
      expect(Validators.email(''), 'Email is required');
    });

    test('returns error for invalid email format', () {
      expect(Validators.email('not-an-email'), 'Invalid email format');
    });

    test('returns error for email without domain', () {
      expect(Validators.email('user@'), 'Invalid email format');
    });
  });

  group('Validators.password', () {
    test('returns null for valid password (6+ chars)', () {
      expect(Validators.password('abcdef'), isNull);
      expect(Validators.password('1234567890'), isNull);
    });

    test('returns error for null input', () {
      expect(Validators.password(null), 'Password is required');
    });

    test('returns error for empty input', () {
      expect(Validators.password(''), 'Password is required');
    });

    test('returns error for too short password', () {
      expect(Validators.password('abc'), 'Password must be at least 6 characters');
    });
  });

  group('Validators.phone', () {
    test('returns null for valid phone number', () {
      expect(Validators.phone('08123456789'), isNull);
      expect(Validators.phone('+621234567890'), isNull);
      expect(Validators.phone('021-1234567'), isNull);
    });

    test('returns error for null input', () {
      expect(Validators.phone(null), 'Phone number is required');
    });

    test('returns error for empty input', () {
      expect(Validators.phone(''), 'Phone number is required');
    });

    test('returns error for too short phone', () {
      expect(Validators.phone('123'), 'Invalid phone number');
    });
  });

  group('Validators.required', () {
    test('returns null for non-empty value', () {
      expect(Validators.required('hello'), isNull);
    });

    test('returns error for null input', () {
      expect(Validators.required(null), 'This field is required');
    });

    test('returns error for empty input', () {
      expect(Validators.required(''), 'This field is required');
    });

    test('returns error for whitespace-only input', () {
      expect(Validators.required('   '), 'This field is required');
    });

    test('uses custom field name', () {
      expect(Validators.required(null, 'Email'), 'Email is required');
    });
  });

  group('Validators.maxChars', () {
    test('returns null when under limit', () {
      expect(Validators.maxChars('hello', 10), isNull);
    });

    test('returns null when exactly at limit', () {
      expect(Validators.maxChars('1234567890', 10), isNull);
    });

    test('returns error when over limit', () {
      expect(
        Validators.maxChars('hello world', 5),
        'This field must be at most 5 characters',
      );
    });

    test('uses custom field name', () {
      expect(
        Validators.maxChars('abcdef', 3, 'Username'),
        'Username must be at most 3 characters',
      );
    });

    test('returns null for null value (skip validation)', () {
      expect(Validators.maxChars(null, 10), isNull);
    });
  });
}
