// lib/features/doctor/domain/repository/doctor_repository.dart

import '../../../../core/network/result.dart';
import '../entity/doctor_entity.dart';
import '../entity/doctor_slot_entity.dart';

abstract class DoctorRepository {
  /// Search/list dokter dengan filter opsional.
  /// API Contract §5.1
  Future<Result<List<DoctorEntity>>> getDoctors({
    String? specializationId,
    String? query,
    int limit = 20,
    int offset = 0,
  });

  /// Get detail satu dokter.
  /// API Contract §5.3
  Future<Result<DoctorEntity>> getDoctorDetail(String doctorId);

  /// Get available slots untuk dokter di tanggal tertentu.
  /// API Contract §5.4
  Future<Result<List<DoctorSlotEntity>>> getDoctorSlots(
    String doctorId,
    DateTime date,
  );

  /// Count available slots (is_booked=false) untuk 7 hari ke depan.
  /// Untuk display "Tersedia X slot" di Doctor Detail (per SS#10).
  Future<Result<int>> getAvailableSlotCount({
    required String doctorId,
    int daysAhead = 7,
  });
}
