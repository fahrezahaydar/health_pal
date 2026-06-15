import 'dart:async';
import 'dart:io';

/// Menjalankan [fn] dengan retry mechanism untuk network-related errors.
///
/// Hanya retry untuk:
/// - `SocketException` (no internet, timeout koneksi)
/// - `TimeoutException` (query timeout > 10s)
///
/// Exponential backoff: 1s, 2s, 4s (untuk 2 retry = maxRetries).
/// Error lain (`PostgrestException`, `AuthException`, dll) langsung
/// di-rethrow — tidak di-retry (tidak akan sembuh dengan menunggu).
///
/// ## Sprint 2 — B8
/// Dipakai di repository layer untuk transient network resilience.
///
/// ```dart
/// final remote = await withRetry(() => _remote.fetchBanners());
/// ```
Future<T> withRetry<T>(
  Future<T> Function() fn, {
  int maxRetries = 2,
}) async {
  for (var i = 0; i <= maxRetries; i++) {
    try {
      return await fn();
    } on SocketException {
      if (i == maxRetries) rethrow;
      await Future.delayed(Duration(seconds: 1 << i));
    } on TimeoutException {
      if (i == maxRetries) rethrow;
      await Future.delayed(Duration(seconds: 1 << i));
    }
  }
  // Fallback: jika maxRetries < 0 (teoritis — tidak mungkin di kode real).
  return fn();
}
