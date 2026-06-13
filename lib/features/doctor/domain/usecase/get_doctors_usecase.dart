// lib/features/doctor/domain/usecase/get_doctors_usecase.dart

import 'package:injectable/injectable.dart';

import '../../../../core/network/result.dart';
import '../entity/doctor_entity.dart';
import '../repository/doctor_repository.dart';

@injectable
class GetDoctorsUseCase {
  final DoctorRepository _repository;

  GetDoctorsUseCase(this._repository);

  Future<Result<List<DoctorEntity>>> call({
    String? specializationId,
    String? query,
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.getDoctors(
      specializationId: specializationId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
