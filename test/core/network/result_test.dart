// test/core/network/result_test.dart
//
// Unit test untuk Result<T> sealed class.
// Referensi: lib/core/network/result.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/api_exception.dart';
import 'package:health_pal/core/network/result.dart';

void main() {
  group('Result.success', () {
    test('returns Success<T> with matching data type', () {
      final result = Result.success(42);
      expect(result, isA<Success<int>>());
    });

    test('Success.data contains the provided value', () {
      const data = 'test-data';
      final result = Result.success(data);
      expect(result, isA<Success<String>>());
      (result as Success<String>).data;
      // Note: Success.data is final, no need to access via getter
      expect(result.data, data);
    });

    test('can be matched with switch (is Success)', () {
      final result = Result.success('hello');
      var matched = false;
      switch (result) {
        case Success<String>():
          matched = true;
        case Failure<String>():
          break;
      }
      expect(matched, isTrue);
    });
  });

  group('Result.failure', () {
    test('returns Failure<T> with correct code and message', () {
      const exception = ApiException(
        code: FailureCode.notFound,
        message: 'Not found',
      );
      final result = Result.failure(exception);
      expect(result, isA<Failure<void>>());
      (result as Failure<void>);
      expect(result.code, FailureCode.notFound);
      expect(result.message, 'Not found');
    });

    test('Failure.exception contains the original ApiException', () {
      const exception = ApiException(
        code: FailureCode.serverError,
        message: 'Server error',
      );
      final result = Result.failure(exception);
      expect(result, isA<Failure<void>>());
      (result as Failure<void>);
      expect(result.exception, same(exception));
    });

    test('can be matched with switch (is Failure)', () {
      final result = Result.failure(const ApiException(
        code: FailureCode.timeout,
        message: 'Timeout',
      ));
      var matched = false;
      switch (result) {
        case Success<void>():
          break;
        case Failure<void>():
          matched = true;
      }
      expect(matched, isTrue);
    });
  });

  group('Pattern matching', () {
    test('switch exhaustiveness works for Success and Failure', () {
      final results = <Result<int>>[
        Result.success(1),
        Result.failure(const ApiException(
          code: FailureCode.unknown, message: 'err')),
      ];

      for (final result in results) {
        switch (result) {
          case Success<int>():
            expect(result.data, 1);
          case Failure<int>():
            expect(result.code, FailureCode.unknown);
        }
      }
    });
  });
}
