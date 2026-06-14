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
  /// Umum: 401/403 = RLS/auth, 404 = bucket tidak ada, 5xx = server.
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
        // StorageException.message sudah human-readable dari Supabase
        // (e.g. "Bucket not found", "new row violates row-level security
        // policy", "Payload too large"). Fallback ke `toString()` agar
        // status code + error code tetap muncul kalau message kosong.
        final StorageException e => e.message.isNotEmpty
            ? e.message
            : e.toString(),
        final TimeoutException _ => 'Request timed out',
        final SocketException _ => 'No internet connection',
        final HttpException e => e.message,
        _ => 'An unexpected error occurred',
      };
}
