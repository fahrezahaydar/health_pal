// test/core/network/error_handler_test.dart
//
// Unit test untuk ErrorHandler — mapping 7 exception types + handleWithAuthCheck.
// Referensi: lib/core/network/error_handler.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_pal/core/enums/failure_code.dart';
import 'package:health_pal/core/network/error_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const handler = ErrorHandler();

  group('map() — PostgrestException', () {
    test('PGRST116 maps to notFound', () {
      const e = PostgrestException(message: 'Not found', code: 'PGRST116');
      final result = handler.map(e);
      expect(result.code, FailureCode.notFound);
      expect(result.message, 'Not found');
    });

    test('23505 maps to conflict', () {
      const e = PostgrestException(message: 'Duplicate', code: '23505');
      final result = handler.map(e);
      expect(result.code, FailureCode.conflict);
    });

    test('23503 maps to conflict', () {
      const e = PostgrestException(message: 'FK violation', code: '23503');
      final result = handler.map(e);
      expect(result.code, FailureCode.conflict);
    });

    test('42P01 maps to serverError', () {
      const e = PostgrestException(message: 'Undefined table', code: '42P01');
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });

    test('unexpected code maps to serverError', () {
      const e = PostgrestException(message: 'Unknown error', code: 'XXX');
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });

    test('null code maps to serverError', () {
      const e = PostgrestException(message: 'No code');
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });

    test('null code with no args maps to serverError', () {
      const e = PostgrestException(message: 'err');
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });
  });

  group('map() — P0001 RAISE EXCEPTION message parsing', () {
    test('ALREADY_BOOKED maps to conflict', () {
      const e = PostgrestException(
        message: 'SLOT_ALREADY_BOOKED',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.conflict);
    });

    test('FORBIDDEN maps to forbidden', () {
      const e = PostgrestException(
        message: 'FORBIDDEN_ACTION',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.forbidden);
    });

    test('NOT_FOUND maps to notFound', () {
      const e = PostgrestException(
        message: 'RECORD_NOT_FOUND',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.notFound);
    });

    test('INVALID_STATUS_TRANSITION maps to validationError', () {
      const e = PostgrestException(
        message: 'INVALID_STATUS_TRANSITION',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.validationError);
    });

    test('CANCEL_WINDOW_EXPIRED maps to validationError', () {
      const e = PostgrestException(
        message: 'CANCEL_WINDOW_EXPIRED',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.validationError);
    });

    test('VALIDATION_ERROR maps to validationError', () {
      const e = PostgrestException(
        message: 'VALIDATION_ERROR',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.validationError);
    });

    test('unknown P0001 message maps to serverError', () {
      const e = PostgrestException(
        message: 'UNKNOWN_CODE',
        code: 'P0001',
      );
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });
  });

  group('map() — AuthException', () {
    test('AuthException maps to unauthorized', () {
      const e = AuthException('Invalid credentials');
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
      expect(result.message, 'Invalid credentials');
    });

    test('AuthException subclass also maps to unauthorized', () {
      const e = AuthException('Session expired', statusCode: '401');
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
    });
  });

  group('map() — StorageException', () {
    test('status 401 maps to unauthorized', () {
      const e = StorageException('Unauthorized', statusCode: '401');
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
    });

    test('status 403 maps to unauthorized', () {
      const e = StorageException('Forbidden', statusCode: '403');
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
    });

    test('status 404 maps to notFound', () {
      const e = StorageException('Not found', statusCode: '404');
      final result = handler.map(e);
      expect(result.code, FailureCode.notFound);
    });

    test('status 500 maps to serverError', () {
      const e = StorageException('Server error', statusCode: '500');
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });

    test('status 400 maps to badRequest', () {
      const e = StorageException('Bad request', statusCode: '400');
      final result = handler.map(e);
      expect(result.code, FailureCode.badRequest);
    });

    test('null statusCode maps to unknown', () {
      const e = StorageException('No status');
      final result = handler.map(e);
      expect(result.code, FailureCode.unknown);
    });

    test('non-numeric statusCode maps to unknown', () {
      const e = StorageException('Bad', statusCode: 'abc');
      final result = handler.map(e);
      expect(result.code, FailureCode.unknown);
    });
  });

  group('map() — FunctionException', () {
    test('status 401 maps to unauthorized', () {
      const e = FunctionException(status: 401);
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
    });

    test('status 403 maps to unauthorized', () {
      const e = FunctionException(status: 403);
      final result = handler.map(e);
      expect(result.code, FailureCode.unauthorized);
    });

    test('status 404 maps to notFound', () {
      const e = FunctionException(status: 404);
      final result = handler.map(e);
      expect(result.code, FailureCode.notFound);
    });

    test('status 409 maps to conflict', () {
      const e = FunctionException(status: 409);
      final result = handler.map(e);
      expect(result.code, FailureCode.conflict);
    });

    test('status 422 maps to validationError', () {
      const e = FunctionException(status: 422);
      final result = handler.map(e);
      expect(result.code, FailureCode.validationError);
    });

    test('status 500 maps to serverError', () {
      const e = FunctionException(status: 500);
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });

    test('status 400 maps to badRequest', () {
      const e = FunctionException(status: 400);
      final result = handler.map(e);
      expect(result.code, FailureCode.badRequest);
    });

    test('status 300 (unexpected) maps to serverError', () {
      const e = FunctionException(status: 300);
      final result = handler.map(e);
      expect(result.code, FailureCode.serverError);
    });
  });

  group('map() — TimeoutException', () {
    test('TimeoutException maps to timeout', () {
      final e = TimeoutException('Request timed out');
      final result = handler.map(e);
      expect(result.code, FailureCode.timeout);
      expect(result.message, 'Request timed out');
    });
  });

  group('map() — SocketException', () {
    test('SocketException maps to networkError', () {
      const e = SocketException('No internet');
      final result = handler.map(e);
      expect(result.code, FailureCode.networkError);
      expect(result.message, 'No internet connection');
    });
  });

  group('map() — HttpException', () {
    test('HttpException maps to networkError', () {
      const e = HttpException('HTTP error');
      final result = handler.map(e);
      expect(result.code, FailureCode.networkError);
      expect(result.message, 'HTTP error');
    });
  });

  group('map() — unknown error', () {
    test('unexpected Object maps to unknown', () {
      final result = handler.map('string error' as Object);
      expect(result.code, FailureCode.unknown);
      expect(result.message, 'An unexpected error occurred');
    });

    test('Exception with no specific type maps to unknown', () {
      final e = Exception('Generic');
      final result = handler.map(e);
      expect(result.code, FailureCode.unknown);
    });
  });

  group('handleWithAuthCheck', () {
    test('calls onUnauthorized when error is AuthException (unauthorized)',
        () async {
      var called = false;
      const e = AuthException('Token expired');
      await ErrorHandler.handleWithAuthCheck(
        e,
        onUnauthorized: () async {
          called = true;
        },
      );
      expect(called, isTrue);
    });

    test('calls onUnauthorized when StorageException is 401', () async {
      var called = false;
      const e = StorageException('Unauthorized', statusCode: '401');
      await ErrorHandler.handleWithAuthCheck(
        e,
        onUnauthorized: () async {
          called = true;
        },
      );
      expect(called, isTrue);
    });

    test('does NOT call onUnauthorized when error is not unauthorized',
        () async {
      var called = false;
      const e = PostgrestException(message: 'Not found', code: 'PGRST116');
      await ErrorHandler.handleWithAuthCheck(
        e,
        onUnauthorized: () async {
          called = true;
        },
      );
      expect(called, isFalse);
    });

    test('returns ApiException with correct code and message', () async {
      const e = PostgrestException(message: 'Not found', code: 'PGRST116');
      final result = await ErrorHandler.handleWithAuthCheck(
        e,
        onUnauthorized: () async {},
      );
      expect(result.code, FailureCode.notFound);
      expect(result.message, 'Not found');
    });
  });
}
