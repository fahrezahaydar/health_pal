// test/core/network/api_exception_test.dart
//
// Unit test untuk ApiException.
// Referensi: lib/core/network/api_exception.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    test('creates with required fields', () {
      final e = ApiException(
        code: FailureCode.notFound,
        message: 'Resource not found',
      );
      expect(e.code, FailureCode.notFound);
      expect(e.message, 'Resource not found');
    });

    test('statusCode is null by default', () {
      final e = ApiException(
        code: FailureCode.serverError,
        message: 'Error',
      );
      expect(e.statusCode, isNull);
    });

    test('response is null by default', () {
      final e = ApiException(
        code: FailureCode.serverError,
        message: 'Error',
      );
      expect(e.response, isNull);
    });

    test('can set statusCode and response', () {
      final e = ApiException(
        code: FailureCode.badRequest,
        message: 'Bad request',
        statusCode: 400,
        response: {'field': 'name', 'error': 'required'},
      );
      expect(e.statusCode, 400);
      expect(e.response, {'field': 'name', 'error': 'required'});
    });

    test('toString format includes FailureCode enum', () {
      final e = ApiException(
        code: FailureCode.unauthorized,
        message: 'Token expired',
      );
      expect(e.toString(), 'ApiException(FailureCode.unauthorized): Token expired');
    });
  });

  group('ApiException implements Exception', () {
    test('can be caught as Exception', () {
      final e = ApiException(
        code: FailureCode.timeout,
        message: 'Timed out',
      );
      expect(e, isA<Exception>());
    });
  });
}
