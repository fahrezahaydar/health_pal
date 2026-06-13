// lib/features/booking/domain/usecase/get_appointment_history_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/appointment_entity.dart';
import '../repository/booking_repository.dart';

@injectable
class GetAppointmentHistoryUseCase {
  final BookingRepository _repository;

  GetAppointmentHistoryUseCase(this._repository);

  Future<Result<List<AppointmentEntity>>> call({
    required String patientId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getAppointmentHistory(
      patientId: patientId,
      status: status,
      limit: limit,
      offset: offset,
    );
  }
}
