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

  String _mapMessage(Object error) => switch (error) {
        final PostgrestException e => e.message,
        final AuthException e => e.message,
        final TimeoutException _ => 'Request timed out',
        final SocketException _ => 'No internet connection',
        final HttpException e => e.message,
        _ => 'An unexpected error occurred',
      };
}
