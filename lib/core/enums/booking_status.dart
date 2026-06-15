import 'package:json_annotation/json_annotation.dart';

/// Status appointment — dipakai di semua feature yang involve
/// appointment lifecycle.
///
/// **Sprint 2 — A5:** tambah `@JsonValue` annotations + `fromJson`
/// safe parser (bukan `BookingStatus.values.firstWhere` yang silent
/// fallback ke `pending` tanpa warning).
///
/// Mapping server -> enum:
/// - `pending`    → Booking telah dibuat, menunggu konfirmasi
/// - `upcoming`   → Booking dikonfirmasi, jadwal belum tiba
/// - `completed`  → Kunjungan selesai
/// - `cancelled`  → Dibatalkan oleh user atau sistem
enum BookingStatus {
  @JsonValue('pending') pending,
  @JsonValue('upcoming') upcoming,
  @JsonValue('completed') completed,
  @JsonValue('cancelled') cancelled;

  /// Safe parser dari raw string API response.
  ///
  /// Pakai `switch` eksplisit (bukan `firstWhere + orElse`) agar:
  /// 1. Semua known value tercantum — implicit documentation.
  /// 2. Unknown value (`_ =>`) explicit fallback ke `pending` —
  ///    tidak silent seperti `orElse: () => BookingStatus.pending`.
  ///    Kalau server kirim value baru (mis. `rescheduled`),
  ///    fallback ke `pending` (safe default).
  /// 3. Mudah di-audit kalau ada status baru — tambah case.
  static BookingStatus fromJson(String? value) {
    return switch (value) {
      'pending' => BookingStatus.pending,
      'upcoming' => BookingStatus.upcoming,
      'completed' => BookingStatus.completed,
      'cancelled' => BookingStatus.cancelled,
      _ => BookingStatus.pending,
    };
  }
}
