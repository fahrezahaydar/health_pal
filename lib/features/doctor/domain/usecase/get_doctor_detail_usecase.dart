// lib/features/doctor/domain/usecase/get_doctor_detail_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/doctor_entity.dart';
import '../repository/doctor_repository.dart';

@injectable
class GetDoctorDetailUseCase {
  final DoctorRepository _repository;

  GetDoctorDetailUseCase(this._repository);

  Future<Result<DoctorEntity>> call(String doctorId) =>
      _repository.getDoctorDetail(doctorId);
}
