// lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/doctor_entity.dart';
import '../../../domain/entity/doctor_schedule_entity.dart';
import '../../../domain/usecase/get_doctor_detail_usecase.dart';
import '../../../domain/usecase/get_doctor_schedules_usecase.dart';
import 'doctor_detail_state.dart';

@injectable
class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final GetDoctorDetailUseCase _getDetail;
  final GetDoctorSchedulesUseCase _getSchedules;

  DoctorDetailCubit(this._getDetail, this._getSchedules)
      : super(const DoctorDetailInitial());

  /// Load doctor detail + schedules.
  Future<void> loadDetail(
    String doctorId, {
    String? suggestedSlotId,
  }) async {
    emit(const DoctorDetailLoading());

    final detailResult = await _getDetail(doctorId);
    DoctorEntity? doctor;
    String? errorMsg;

    switch (detailResult) {
      case Success<DoctorEntity>():
        doctor = detailResult.data;
      case Failure<DoctorEntity>():
        errorMsg = detailResult.message;
    }

    if (doctor == null) {
      emit(DoctorDetailError(message: errorMsg ?? 'Doctor not found'));
      return;
    }

    // Fetch schedules parallel (fallback if nested select returns empty)
    List<DoctorScheduleEntity> schedules = doctor.schedules;
    if (schedules.isEmpty) {
      final schedulesResult = await _getSchedules(doctorId);
      switch (schedulesResult) {
        case Success<List<DoctorScheduleEntity>>():
          schedules = schedulesResult.data;
        case Failure<List<DoctorScheduleEntity>>():
          schedules = const [];
      }
    }

    emit(DoctorDetailLoaded(
      doctor: doctor,
      schedules: schedules,
      suggestedSlotId: suggestedSlotId,
    ));
  }
}
