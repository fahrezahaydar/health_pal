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
        final TimeoutException _ => FailureCode.timeout,
        final SocketException _ => FailureCode.networkError,
        final HttpException _ => FailureCode.networkError,
        _ => FailureCode.unknown,
      };

  FailureCode _mapPostgrestCode(PostgrestException e) => switch (e.code) {
        'PGRST116' => FailureCode.notFound,
        '23505' => FailureCode.conflict,
        '23503' => FailureCode.conflict,
        '42P01' => FailureCode.serverError,
        _ => FailureCode.serverError,
      };

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

  String _mapMessage(Object error) => switch (error) {
        final PostgrestException e => e.message,
        final AuthException e => e.message,
        final StorageException e =>
            e.message.isNotEmpty ? e.message : e.toString(),
        final TimeoutException _ => 'Request timed out',
        final SocketException _ => 'No internet connection',
        final HttpException e => e.message,
        _ => 'An unexpected error occurred',
      };
}
