// test/core/enums/gender_test.dart
//
// Unit test untuk Gender enum (enhanced enum with `value` field).
// Referensi: lib/core/enums/gender.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/gender.dart';

void main() {
  group('Gender values', () {
    test('has exactly 3 values', () {
      expect(Gender.values.length, 3);
    });

    test('contains all expected values', () {
      expect(Gender.values, containsAll([
        Gender.male,
        Gender.female,
        Gender.notSpecified,
      ]));
    });

    test('male has correct display value', () {
      expect(Gender.male.value, 'Male');
    });

    test('female has correct display value', () {
      expect(Gender.female.value, 'Female');
    });

    test('notSpecified has correct display value', () {
      expect(Gender.notSpecified.value, 'Not Specified');
    });
  });
}
