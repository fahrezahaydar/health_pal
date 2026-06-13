// lib/features/booking/domain/usecase/get_appointment_detail_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/appointment_entity.dart';
import '../repository/booking_repository.dart';

@injectable
class GetAppointmentDetailUseCase {
  final BookingRepository _repository;

  GetAppointmentDetailUseCase(this._repository);

  Future<Result<AppointmentEntity>> call({
    required String patientId,
    required String appointmentId,
  }) {
    return _repository.getAppointmentDetail(
      patientId: patientId,
      appointmentId: appointmentId,
    );
  }
}
