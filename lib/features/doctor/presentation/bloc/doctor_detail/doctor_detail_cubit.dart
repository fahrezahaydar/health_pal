// lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/doctor_entity.dart';
import '../../../domain/entity/doctor_slot_entity.dart';
import '../../../domain/usecase/get_doctor_detail_usecase.dart';
import '../../../domain/usecase/get_doctor_slots_usecase.dart';
import 'doctor_detail_state.dart';

@injectable
class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final GetDoctorDetailUseCase _getDetail;
  final GetDoctorSlotsUseCase _getSlots;

  DoctorDetailCubit(this._getDetail, this._getSlots)
      : super(const DoctorDetailInitial());

  /// Load doctor detail + available slot count + sample 5 slot.
  /// SS#10 compliance: TIDAK ADA date picker. Hanya info slot count.
  Future<void> loadDetail(
    String doctorId, {
    String? suggestedSlotId,
  }) async {
    emit(const DoctorDetailLoading());

    // 1. Get detail
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

    // 2. Get available slot count (7 hari ke depan)
    int availableCount = 0;
    final countResult = await _getSlots.callAvailableCount(doctorId);
    switch (countResult) {
      case Success<int>():
        availableCount = countResult.data;
      case Failure<int>():
        // non-fatal: tampilkan 0 jika gagal hitung
        availableCount = 0;
    }

    // 3. Get sample 5 slot (untuk preview)
    final today = DateTime.now();
    final slotsResult = await _getSlots(doctorId, today);
    List<DoctorSlotEntity> sampleSlots = const [];
    switch (slotsResult) {
      case Success<List<DoctorSlotEntity>>():
        sampleSlots = slotsResult.data.take(5).toList();
      case Failure<List<DoctorSlotEntity>>():
        // non-fatal
        sampleSlots = const [];
    }

    emit(DoctorDetailLoaded(
      doctor: doctor,
      sampleSlots: sampleSlots,
      availableSlotCount: availableCount,
      suggestedSlotId: suggestedSlotId,
    ));
  }
}
