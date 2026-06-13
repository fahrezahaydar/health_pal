// lib/features/booking/domain/usecase/cancel_appointment_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/appointment_entity.dart';
import '../repository/booking_repository.dart';

@injectable
class CancelAppointmentUseCase {
  final BookingRepository _repository;

  CancelAppointmentUseCase(this._repository);

  Future<Result<AppointmentEntity>> call({
    required String appointmentId,
    String? cancellationReason,
  }) {
    return _repository.cancelAppointment(
      appointmentId: appointmentId,
      cancellationReason: cancellationReason,
    );
  }
}
