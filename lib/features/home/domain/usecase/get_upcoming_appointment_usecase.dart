import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/upcoming_appointment_entity.dart';
import '../repository/home_repository.dart';

@injectable
class GetUpcomingAppointmentUseCase {
  final HomeRepository _repository;

  GetUpcomingAppointmentUseCase(this._repository);

  Future<Result<UpcomingAppointmentEntity?>> call(String profileId) =>
      _repository.getUpcoming(profileId);
}
