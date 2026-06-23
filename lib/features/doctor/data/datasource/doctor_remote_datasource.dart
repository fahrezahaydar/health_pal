// lib/features/doctor/data/datasource/doctor_remote_datasource.dart
//
// DataSource untuk doctor endpoints. Pattern sama dengan
// HomeRemoteDataSource (lib/features/home/data/datasource).

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/doctor_model.dart';
import '../model/doctor_slot_model.dart';

@injectable
class DoctorRemoteDataSource {
  final SupabaseClient _client;

  DoctorRemoteDataSource(this._client);

  // ── API §5.1 Search Dokter ────────────────────────────
  Future<List<DoctorModel>> searchDoctors({
    String? specializationId,
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    // Build select clause. Order harus setelah select selesai.
    var builder = _client
        .from('doctors')
        .select(
            '*, clinics(id, name, address, city), specializations(id, name, icon_url, color_hex)')
        .eq('is_active', true);

    if (specializationId != null) {
      builder = builder.eq('specialization_id', specializationId);
    }
    if (query != null && query.isNotEmpty) {
      builder = builder.or(
        'full_name.ilike.*$query*,specializations.name.ilike.*$query*',
      );
    }

    // Order + range di chain TERAKHIR (PostgrestTransformBuilder).
    final result = await builder
        .order('rating_avg', ascending: false)
        .range(offset, offset + limit - 1);

    return (result as List)
        .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── API §5.3 Get Detail Dokter ──────────────────────────
  Future<DoctorModel> getDoctorDetail(String doctorId) async {
    final result = await _client
        .from('doctors')
        .select(
            '*, clinics(id, name, address, city, latitude, longitude, phone), specializations(id, name, icon_url, color_hex)')
        .eq('id', doctorId)
        .eq('is_active', true)
        .single();

    return DoctorModel.fromJson(result);
  }

  // ── API §5.4 Get Slot Tersedia ──────────────────────────
  Future<List<DoctorSlotModel>> getDoctorSlots(
    String doctorId,
    DateTime date,
  ) async {
    final dateStr = _formatDateOnly(date);

    final result = await _client
        .from('doctor_slots')
        .select()
        .eq('doctor_id', doctorId)
        .eq('slot_date', dateStr)
        .eq('is_booked', false)
        .order('slot_start', ascending: true);

    return (result as List)
        .map((e) => DoctorSlotModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Count available slots dalam N hari ke depan (untuk SS#10) ──
  Future<int> getAvailableSlotCount({
    required String doctorId,
    int daysAhead = 7,
  }) async {
    final now = DateTime.now();
    final future = now.add(Duration(days: daysAhead));
    final fromStr = _formatDateOnly(now);
    final toStr = _formatDateOnly(future);

    final result = await _client
        .from('doctor_slots')
        .select('id')
        .eq('doctor_id', doctorId)
        .eq('is_booked', false)
        .gte('slot_date', fromStr)
        .lte('slot_date', toStr);

    return (result as List).length;
  }

  // ── Helper ──
  String _formatDateOnly(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
