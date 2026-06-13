// lib/features/booking/data/repository/booking_repository_impl.dart
//
// Implementasi BookingRepository. Pattern sama dengan
// HomeRepositoryImpl / DoctorRepositoryImpl — try/catch + Result<T> wrapping.

import 'package:injectable/injectable.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/result.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasource/booking_remote_datasource.dart';
import '../model/appointment_model.dart';

@Injectable(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remote;

  BookingRepositoryImpl(this._remote);

  @override
  Future<Result<AppointmentEntity>> createAppointment({
    required String doctorId,
    required String slotId,
    String? complaintNote,
  }) async {
    try {
      final remote = await _remote.createAppointment(
        doctorId: doctorId,
        slotId: slotId,
        complaintNote: complaintNote,
      );
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<List<AppointmentEntity>>> getAppointmentHistory({
    required String patientId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final remote = await _remote.getAppointmentHistory(
        patientId: patientId,
        status: status,
        limit: limit,
        offset: offset,
      );
      return Result.success(remote.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<AppointmentEntity>> getAppointmentDetail({
    required String patientId,
    required String appointmentId,
  }) async {
    try {
      final remote = await _remote.getAppointmentDetail(
        patientId: patientId,
        appointmentId: appointmentId,
      );
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }

  @override
  Future<Result<AppointmentEntity>> cancelAppointment({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    try {
      final remote = await _remote.cancelAppointment(
        appointmentId: appointmentId,
        cancellationReason: cancellationReason,
      );
      return Result.success(remote.toEntity());
    } catch (e) {
      return Result.failure(const ErrorHandler().map(e));
    }
  }
}
