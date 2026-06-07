import 'api_exception.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);

  factory Result.failure(ApiException e) =>
      Failure(e.code.name, e.message, e);
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.code, this.message, [this.exception]);

  final String code;
  final String message;
  final Object? exception;
}
