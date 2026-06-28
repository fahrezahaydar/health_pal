// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorScheduleModel _$DoctorScheduleModelFromJson(Map<String, dynamic> json) =>
    _DoctorScheduleModel(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slotDurationMinutes:
          (json['slot_duration_minutes'] as num?)?.toInt() ?? 30,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$DoctorScheduleModelToJson(
  _DoctorScheduleModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'doctor_id': instance.doctorId,
  'day_of_week': instance.dayOfWeek,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'slot_duration_minutes': instance.slotDurationMinutes,
  'is_active': instance.isActive,
};
