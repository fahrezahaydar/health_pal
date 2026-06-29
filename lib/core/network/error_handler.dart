import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../enums/failure_code.dart';
import 'api_exception.dart';

class ErrorHandler {
  const ErrorHandler();

  ApiException map(Object error) {
    final code = _mapFailureCode(error);
    final message = _mapMessage(error);

    return ApiException(
      code: code,
      message: message,
    );
  }

  /// **Sprint 2 — B7:** sama seperti `map()`, tapi jika error adalah
  /// `unauthorized` (401 / RLS deny / token expired), panggil
  /// [onUnauthorized] callback (biasanya `AppServices.logout()`).
  ///
  /// Dipakai di repository catch block sebagai drop-in replacement
  /// untuk `const ErrorHandler().map(e)`:
  ///
  /// ```dart
  /// return Result.failure(
  ///   await ErrorHandler.handleWithAuthCheck(e, () => appServices.logout()),
  /// );
  /// ```
  static Future<ApiException> handleWithAuthCheck(
    Object error, {
    required Future<void> Function() onUnauthorized,
  }) async {
    final mapped = const ErrorHandler().map(error);
    if (mapped.code == FailureCode.unauthorized) {
      await onUnauthorized();
    }
    return mapped;
  }

  FailureCode _mapFailureCode(Object error) => switch (error) {
        final PostgrestException e => _mapPostgrestCode(e),
        final AuthException _ => FailureCode.unauthorized,
        final StorageException e => _mapStorageCode(e),
        final FunctionException e => _mapFunctionCode(e),
        final TimeoutException _ => FailureCode.timeout,
        final SocketException _ => FailureCode.networkError,
        final HttpException _ => FailureCode.networkError,
        _ => FailureCode.unknown,
      };

  /// Map PostgREST error code ke [FailureCode].
  /// Untuk custom RAISE EXCEPTION (P0001) parse [e.message] untuk kode spesifik.
  FailureCode _mapPostgrestCode(PostgrestException e) => switch (e.code) {
        'PGRST116' => FailureCode.notFound,
        '23505' => FailureCode.conflict,
        '23503' => FailureCode.conflict,
        '42P01' => FailureCode.serverError,
        'P0001' => _mapP0001Message(e.message),
        _ => FailureCode.serverError,
      };

  /// Parse message dari custom RAISE EXCEPTION di RPC.
  /// RPC raise exception 'SLOT_ALREADY_BOOKED' → message='SLOT_ALREADY_BOOKED'
  FailureCode _mapP0001Message(String message) {
    if (message.contains('ALREADY_BOOKED')) return FailureCode.conflict;
    if (message.contains('FORBIDDEN')) return FailureCode.forbidden;
    if (message.contains('NOT_FOUND')) return FailureCode.notFound;
    if (message.contains('INVALID_STATUS_TRANSITION') ||
        message.contains('CANCEL_WINDOW_EXPIRED') ||
        message.contains('VALIDATION_ERROR')) {
      return FailureCode.validationError;
    }
    return FailureCode.serverError;
  }

  /// Map Supabase Storage error ke [FailureCode] berdasarkan HTTP status.
  FailureCode _mapStorageCode(StorageException e) {
    final status = int.tryParse(e.statusCode ?? '');
    if (status == null) return FailureCode.unknown;
    if (status == 401 || status == 403) return FailureCode.unauthorized;
    if (status == 404) return FailureCode.notFound;
    if (status >= 500) return FailureCode.serverError;
    if (status >= 400) return FailureCode.badRequest;
    return FailureCode.unknown;
  }

  /// Map Supabase Edge Function error ke [FailureCode] berdasarkan HTTP status.
  FailureCode _mapFunctionCode(FunctionException e) {
    final s = e.status;
    if (s == 401 || s == 403) return FailureCode.unauthorized;
    if (s == 404) return FailureCode.notFound;
    if (s == 409) return FailureCode.conflict;
    if (s == 422) return FailureCode.validationError;
    if (s >= 500) return FailureCode.serverError;
    if (s >= 400) return FailureCode.badRequest;
    return FailureCode.serverError;
  }

  String _mapMessage(Object error) => switch (error) {
        final PostgrestException e => e.message,
        final AuthException e => e.message,
        final StorageException e =>
            e.message.isNotEmpty ? e.message : e.toString(),
        final FunctionException e =>
            e.reasonPhrase ?? e.details?.toString() ?? 'Edge function error',
        final TimeoutException _ => 'Request timed out',
        final SocketException _ => 'No internet connection',
        final HttpException e => e.message,
        _ => 'An unexpected error occurred',
      };
}
