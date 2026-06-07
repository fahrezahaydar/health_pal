import '../enums/failure_code.dart';

class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.response,
  });

  final FailureCode code;
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? response;

  @override
  String toString() => 'ApiException($code): $message';
}
