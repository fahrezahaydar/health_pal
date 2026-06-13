// lib/features/booking/domain/usecase/create_appointment_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/appointment_entity.dart';
import '../repository/booking_repository.dart';

@injectable
class CreateAppointmentUseCase {
  final BookingRepository _repository;

  CreateAppointmentUseCase(this._repository);

  Future<Result<AppointmentEntity>> call({
    required String doctorId,
    required String slotId,
    String? complaintNote,
  }) {
    return _repository.createAppointment(
      doctorId: doctorId,
      slotId: slotId,
      complaintNote: complaintNote,
    );
  }
}
