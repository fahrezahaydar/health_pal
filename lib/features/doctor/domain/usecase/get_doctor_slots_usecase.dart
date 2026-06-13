// lib/features/doctor/domain/usecase/get_doctor_slots_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/doctor_slot_entity.dart';
import '../repository/doctor_repository.dart';

@injectable
class GetDoctorSlotsUseCase {
  final DoctorRepository _repository;

  GetDoctorSlotsUseCase(this._repository);

  Future<Result<List<DoctorSlotEntity>>> call(
    String doctorId,
    DateTime date,
  ) =>
      _repository.getDoctorSlots(doctorId, date);

  /// Count available slots dalam 7 hari ke depan (untuk "Tersedia X slot" text).
  Future<Result<int>> callAvailableCount(
    String doctorId, {
    int daysAhead = 7,
  }) =>
      _repository.getAvailableSlotCount(
        doctorId: doctorId,
        daysAhead: daysAhead,
      );
}
