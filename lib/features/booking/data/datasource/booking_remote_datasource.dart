// lib/features/booking/data/datasource/booking_remote_datasource.dart
//
// DataSource untuk booking endpoints. Pattern sama dengan
// HomeRemoteDataSource / DoctorRemoteDataSource.
//
// Per API Contract §6:
// - 6.1 create-appointment  → RPC create_appointment (atomic transaction)
// - 6.2 get history        → PostgREST list
// - 6.3 get detail          → PostgREST single
// - 6.4 cancel-appointment  → RPC cancel_appointment (atomic transaction)
//
// PostgREST responses adalah array/list langsung.
// RPC responses adalah jsonb langsung (tanpa envelope).
//
// Profile ID didapat dari argumen (bukan dari auth.currentUser.id langsung)
// — untuk konsistensi dengan home datasource yang juga menerima profileId.

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enums/failure_code.dart';
import '../../../../core/network/api_exception.dart';
import '../model/appointment_model.dart';

@injectable
class BookingRemoteDataSource {
  final SupabaseClient _client;

  BookingRemoteDataSource(this._client);

  // ── API §6.1 Create Appointment (RPC) ───────────────────────────────────
  /// Memanggil PostgreSQL function `create_appointment` via RPC.
  /// `patient_id` diambil dari auth.uid() di dalam function.
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String slotId,
    String? complaintNote,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'create_appointment',
      params: {
        'p_doctor_id': doctorId,
        'p_slot_id': slotId,
        if (complaintNote != null && complaintNote.isNotEmpty)
          'p_complaint_note': complaintNote,
      },
    );

    // RPC return key 'slots', model expects 'doctor_slots'
    final data = Map<String, dynamic>.from(response);
    if (data.containsKey('slots') && !data.containsKey('doctor_slots')) {
      data['doctor_slots'] = data.remove('slots');
    }

    return AppointmentModel.fromJson(data);
  }

  // ── API §6.2 Get Booking History (PostgREST) ────────────────────────────
  Future<List<AppointmentModel>> getAppointmentHistory({
    required String patientId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    var builder = _client
        .from('appointments')
        .select(
          '*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
        )
        .eq('patient_id', patientId);

    // Apply status filter BEFORE .order() — PostgrestTransformBuilder
    // (returned by .order) does NOT have .eq().
    if (status != null) {
      builder = builder.eq('status', status);
    }

    final result = await builder
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (result as List)
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── API §6.3 Get Appointment Detail (PostgREST) ─────────────────────────
  Future<AppointmentModel> getAppointmentDetail({
    required String patientId,
    required String appointmentId,
  }) async {
    final result = await _client
        .from('appointments')
        .select(
          '*, doctors(id, full_name, photo_url, experience_years, specializations(name), clinics(name, address, phone)), doctor_slots(slot_date, slot_start, slot_end)',
        )
        .eq('id', appointmentId)
        .eq('patient_id', patientId)
        .maybeSingle();

    if (result == null) {
      throw const ApiException(
        code: FailureCode.notFound,
        message: 'Appointment tidak ditemukan',
      );
    }

    return AppointmentModel.fromJson(result);
  }

  // ── API §6.4 Cancel Appointment (RPC) ────────────────────────────────────
  /// Memanggil PostgreSQL function `cancel_appointment` via RPC.
  /// `patient_id` di-resolve oleh function dari auth.uid().
  /// Response langsung adalah partial appointment jsonb (tanpa envelope).
  /// Setelah cancel, fetch full record untuk konsistensi UI.
  Future<AppointmentModel> cancelAppointment({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'cancel_appointment',
      params: {
        'p_appointment_id': appointmentId,
        if (cancellationReason != null && cancellationReason.isNotEmpty)
          'p_cancellation_reason': cancellationReason,
      },
    );

    // RPC returns {id, status, cancelled_at, cancellation_reason, patient_id, ...}
    final patientId = response['patient_id'] as String? ?? '';

    // Fetch full record untuk konsistensi dengan booking detail state.
    return getAppointmentDetail(
      patientId: patientId,
      appointmentId: appointmentId,
    ).catchError((_) {
      // Fallback: jika fetch detail gagal (RLS issue), return minimal model
      return AppointmentModel(
        id: appointmentId,
        patientId: patientId,
        doctorId: '',
        slotId: '',
        status: 'cancelled',
        consultationFeeSnapshot: 0,
      );
    });
  }
}
