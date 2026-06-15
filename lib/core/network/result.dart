import 'api_exception.dart';
import '../enums/failure_code.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);

  factory Result.failure(ApiException e) =>
      Failure(e.code, e.message, e);
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.code, this.message, [this.exception]);

  /// **Sprint 2 — B3:** type berubah dari `String` ke `FailureCode` enum
  /// (TDD 01 §4.3 compliance). Cubit call site sudah di-update:
  /// `code == FailureCode.notFound` (bukan `FailureCode.notFound.name`).
  final FailureCode code;
  final String message;
  final Object? exception;
}
