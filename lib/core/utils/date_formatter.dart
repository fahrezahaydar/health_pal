import 'package:flutter/material.dart' show TimeOfDay;

/// Formatting helpers untuk display date/time di presentation layer.
///
/// **Sprint 2 — Task A3:** tambah support untuk `TimeOfDay` (slot
/// start/end dari UpcomingAppointmentEntity) + nullable variants untuk
/// safety (jika API kirim null/malformed, fallback ke "—" instead of
/// empty/crash).
class DateFormatter {
  const DateFormatter._();

  // Nama bulan singkat (Bahasa Indonesia) — untuk "15 Jun"
  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  // Nama bulan lengkap (Bahasa Indonesia) — untuk "15 Juni 2026"
  static const _longMonths = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  // Nama hari (Minggu = 0 per DateTime.weekday % 7)
  static const _dayNames = [
    'Minggu', 'Senin', 'Selasa', 'Rabu',
    'Kamis', "Jum'at", 'Sabtu',
  ];

  // Placeholder jika value null atau invalid.
  static const _placeholder = '—';

  /// Format: "15 Jun" (Bahasa Indonesia)
  static String toDayMonth(DateTime date) =>
      '${date.day} ${_shortMonths[date.month - 1]}';

  /// Format: "15 Jun 2026" — short month with year (Bahasa Indonesia).
  static String toShortDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} ${_shortMonths[date.month - 1]} ${date.year}';

  /// Format: "15 Juni 2026" (Bahasa Indonesia)
  static String toFullDate(DateTime date) =>
      '${date.day} ${_longMonths[date.month - 1]} ${date.year}';

  /// Format: "09:00" (24-hour) dari `DateTime`.
  static String toTimeOfDayFromDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format: "09:00" (24-hour) dari `TimeOfDay`.
  /// Digunakan untuk slot_start/slot_end yang TimeOfDay (bukan DateTime).
  static String toTimeOfDayString(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String dayName(int dayOfWeek) => _dayNames[dayOfWeek % 7];

  // ── Nullable variants — Sprint 2 A3 (safe UI rendering) ──

  /// Safe wrapper untuk `toDayMonth`. Returns "—" jika null.
  static String toDayMonthOrDash(DateTime? date) =>
      date == null ? _placeholder : toDayMonth(date);

  /// Safe wrapper untuk `toShortDate`. Returns "—" jika null.
  static String toShortDateOrDash(DateTime? date) =>
      date == null ? _placeholder : toShortDate(date);

  /// Safe wrapper untuk `toFullDate`. Returns "—" jika null.
  static String toFullDateOrDash(DateTime? date) =>
      date == null ? _placeholder : toFullDate(date);

  /// Safe wrapper untuk `toTimeOfDayString`. Returns "—" jika null.
  static String toTimeOfDayStringOrDash(TimeOfDay? tod) =>
      tod == null ? _placeholder : toTimeOfDayString(tod);
}
