// lib/core/network/json_converters.dart
//
// Custom JSON converters untuk format non-standar di PostgreSQL/Supabase:
// - DateOnlyJsonConverter: "YYYY-MM-DD" → DateTime
// - TimeOnlyJsonConverter: "HH:MM:SS" → TimeOfDay
//
// Dipakai di @freezed Model classes untuk konsistensi mapping antara
// snake_case JSON (PostgreSQL) dan Dart DateTime/TimeOfDay.

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:json_annotation/json_annotation.dart';

/// Converter untuk DATE-ONLY format ("2026-06-15") ↔ DateTime.
/// Dipakai untuk: `slot_date`, `date_of_birth`, banner `starts_at`/`ends_at`.
class DateOnlyJsonConverter implements JsonConverter<DateTime?, String?> {
  const DateOnlyJsonConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return DateTime.parse(json);
  }

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;
    return '${object.year.toString().padLeft(4, '0')}-'
        '${object.month.toString().padLeft(2, '0')}-'
        '${object.day.toString().padLeft(2, '0')}';
  }
}

/// Converter untuk TIME-ONLY format ("09:00:00") ↔ TimeOfDay.
/// Dipakai untuk: `slot_start`, `slot_end`.
class TimeOnlyJsonConverter implements JsonConverter<TimeOfDay?, String?> {
  const TimeOnlyJsonConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    final parts = json.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String? toJson(TimeOfDay? object) {
    if (object == null) return null;
    final h = object.hour.toString().padLeft(2, '0');
    final m = object.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }
}

/// Format double ke string Rupiah (untuk presentation layer).
/// Contoh: 150000.0 → "Rp 150.000"
String formatRupiah(double amount) {
  final intPart = amount.toInt();
  final str = intPart.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
    buffer.write(str[i]);
  }
  return 'Rp $buffer';
}
