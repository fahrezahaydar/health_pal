// test/core/enums/failure_code_test.dart
//
// Unit test untuk FailureCode enum.
// Referensi: lib/core/enums/failure_code.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/failure_code.dart';

void main() {
  group('FailureCode values', () {
    test('has exactly 11 values', () {
      expect(FailureCode.values.length, 11);
    });

    test('contains all expected values', () {
      expect(FailureCode.values, containsAll([
        FailureCode.serverError,
        FailureCode.badRequest,
        FailureCode.unauthorized,
        FailureCode.forbidden,
        FailureCode.notFound,
        FailureCode.conflict,
        FailureCode.validationError,
        FailureCode.networkError,
        FailureCode.timeout,
        FailureCode.cacheError,
        FailureCode.unknown,
      ]));
    });
  });
}
