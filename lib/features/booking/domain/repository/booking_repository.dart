// lib/features/booking/domain/repository/booking_repository.dart

import '../../../../core/network/result.dart';
import '../entity/appointment_entity.dart';

abstract class BookingRepository {
  /// API §6.1 — Create appointment via Edge Function (atomic transaction).
  /// `patientId` di-derive server-side dari auth.uid() — tidak perlu dikirim.
  Future<Result<AppointmentEntity>> createAppointment({
    required String doctorId,
    required String slotId,
    String? complaintNote,
  });

  /// API §6.2 — Get appointment history, optional filter by status.
  /// Pagination via limit/offset (default 20 per page).
  Future<Result<List<AppointmentEntity>>> getAppointmentHistory({
    required String patientId,
    String? status,
    int limit = 20,
    int offset = 0,
  });

  /// API §6.3 — Get detail satu appointment.
  Future<Result<AppointmentEntity>> getAppointmentDetail({
    required String patientId,
    required String appointmentId,
  });

  /// API §6.4 — Cancel appointment (Edge Function).
  /// Only valid for status `pending` or `upcoming`.
  Future<Result<AppointmentEntity>> cancelAppointment({
    required String appointmentId,
    String? cancellationReason,
  });
}
