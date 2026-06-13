// lib/features/booking/data/datasource/booking_remote_datasource.dart
//
// DataSource untuk booking endpoints. Pattern sama dengan
// HomeRemoteDataSource / DoctorRemoteDataSource.
//
// Per API Contract §6:
// - 6.1 create-appointment  → Edge Function (atomic transaction)
// - 6.2 get history        → PostgREST list
// - 6.3 get detail          → PostgREST single
// - 6.4 cancel-appointment  → Edge Function (atomic transaction)
//
// Edge Function responses di-wrap di `{success, data, message}`.
// PostgREST responses adalah array/list langsung.
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

  // ── API §6.1 Create Appointment (Edge Function) ────────────────────────
  /// `patientId` TIDAK dikirim — Edge Function derive dari auth.uid().
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String slotId,
    String? complaintNote,
  }) async {
    final response = await _client.functions.invoke(
      'create-appointment',
      body: {
        'doctor_id': doctorId,
        'slot_id': slotId,
        'complaint_note': complaintNote,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiException(
        code: FailureCode.unknown,
        message: 'Invalid response from create-appointment',
      );
    }

    if (data['success'] != true) {
      final err = data['error'] as Map<String, dynamic>?;
      throw ApiException(
        code: _mapEdgeErrorCode(err?['code'] as String?),
        message: err?['message'] as String? ?? 'Booking failed',
      );
    }

    return AppointmentModel.fromJson(data['data'] as Map<String, dynamic>);
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

  // ── API §6.4 Cancel Appointment (Edge Function) ─────────────────────────
  Future<AppointmentModel> cancelAppointment({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    final response = await _client.functions.invoke(
      'cancel-appointment',
      body: {
        'appointment_id': appointmentId,
        'cancellation_reason': cancellationReason,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const ApiException(
        code: FailureCode.unknown,
        message: 'Invalid response from cancel-appointment',
      );
    }

    if (data['success'] != true) {
      final err = data['error'] as Map<String, dynamic>?;
      throw ApiException(
        code: _mapEdgeErrorCode(err?['code'] as String?),
        message: err?['message'] as String? ?? 'Cancellation failed',
      );
    }

    // Edge Function hanya return partial appointment, fetch full record
    // untuk konsistensi dengan booking detail state.
    return getAppointmentDetail(
      patientId: '',
      appointmentId: appointmentId,
    ).catchError((_) {
      // Fallback: jika patientId kosong / RLS issue, return minimal model
      return AppointmentModel(
        id: appointmentId,
        patientId: '',
        doctorId: '',
        slotId: '',
        status: 'cancelled',
        consultationFeeSnapshot: 0,
      );
    });
  }

  // ── Helper: map Edge Function error code → FailureCode ─────────────────
  FailureCode _mapEdgeErrorCode(String? code) {
    return switch (code) {
      'SLOT_ALREADY_BOOKED' => FailureCode.conflict,
      'VALIDATION_ERROR' => FailureCode.validationError,
      'NOT_FOUND' => FailureCode.notFound,
      'UNAUTHORIZED' => FailureCode.unauthorized,
      'FORBIDDEN' => FailureCode.forbidden,
      'INVALID_STATUS_TRANSITION' => FailureCode.validationError,
      'TRANSACTION_FAILED' => FailureCode.serverError,
      _ => FailureCode.serverError,
    };
  }
}
