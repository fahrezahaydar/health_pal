// lib/features/doctor/data/repository/doctor_repository_impl.dart
//
// Implementasi DoctorRepository. Pattern sama dengan
// HomeRepositoryImpl — try/catch + Result<T> wrapping.

import 'package:injectable/injectable.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../domain/entity/doctor_entity.dart';
import '../../domain/entity/doctor_schedule_entity.dart';
import '../../domain/entity/doctor_slot_entity.dart';
import '../../domain/repository/doctor_repository.dart';
import '../datasource/doctor_remote_datasource.dart';
import '../model/doctor_model.dart';
import '../model/doctor_schedule_model.dart';
import '../model/doctor_slot_model.dart';

@Injectable(as: DoctorRepository)
class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource _remote;

  DoctorRepositoryImpl(this._remote);

  @override
  Future<Result<List<DoctorEntity>>> getDoctors({
    String? specializationId,
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final remote = await _remote.searchDoctors(
        specializationId: specializationId,
        query: query,
        limit: limit,
        offset: offset,
      );
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<DoctorEntity>> getDoctorDetail(String doctorId) async {
    try {
      final remote = await _remote.getDoctorDetail(doctorId);
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<DoctorScheduleEntity>>> getDoctorSchedules(
      String doctorId) async {
    try {
      final remote = await _remote.getDoctorSchedules(doctorId);
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<DoctorSlotEntity>>> getDoctorSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      final remote = await _remote.getDoctorSlots(doctorId, date);
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<int>> getAvailableSlotCount({
    required String doctorId,
    int daysAhead = 7,
  }) async {
    try {
      final count = await _remote.getAvailableSlotCount(
        doctorId: doctorId,
        daysAhead: daysAhead,
      );
      return Result.success(count);
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }
}
