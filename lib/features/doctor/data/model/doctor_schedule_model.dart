import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/doctor_schedule_entity.dart';

part 'doctor_schedule_model.freezed.dart';
part 'doctor_schedule_model.g.dart';

@freezed
abstract class DoctorScheduleModel with _$DoctorScheduleModel {
  const DoctorScheduleModel._();

  const factory DoctorScheduleModel({
    required String id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'day_of_week') required int dayOfWeek,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'slot_duration_minutes') @Default(30) int slotDurationMinutes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _DoctorScheduleModel;

  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorScheduleModelFromJson(json);

  factory DoctorScheduleModel.fromEntity(DoctorScheduleEntity entity) =>
      DoctorScheduleModel(
        id: entity.id,
        doctorId: entity.doctorId,
        dayOfWeek: entity.dayOfWeek,
        startTime: entity.startTime,
        endTime: entity.endTime,
        slotDurationMinutes: entity.slotDurationMinutes,
        isActive: entity.isActive,
      );
}

extension DoctorScheduleModelX on DoctorScheduleModel {
  DoctorScheduleEntity toEntity() => DoctorScheduleEntity(
        id: id,
        doctorId: doctorId,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        slotDurationMinutes: slotDurationMinutes,
        isActive: isActive,
      );
}
