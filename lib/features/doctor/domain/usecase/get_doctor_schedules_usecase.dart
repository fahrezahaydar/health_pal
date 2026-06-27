import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/doctor_schedule_entity.dart';
import '../repository/doctor_repository.dart';

@injectable
class GetDoctorSchedulesUseCase {
  final DoctorRepository _repository;

  GetDoctorSchedulesUseCase(this._repository);

  Future<Result<List<DoctorScheduleEntity>>> call(String doctorId) =>
      _repository.getDoctorSchedules(doctorId);
}
