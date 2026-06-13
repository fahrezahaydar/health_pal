// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoctorSlotModel _$DoctorSlotModelFromJson(Map<String, dynamic> json) =>
    _DoctorSlotModel(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      scheduleId: json['schedule_id'] as String?,
      slotDate: _dateFromJson(json['slot_date']),
      startTime: _timeFromJson(json['slot_start']),
      endTime: _timeFromJson(json['slot_end']),
      isBooked: json['is_booked'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DoctorSlotModelToJson(_DoctorSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'schedule_id': instance.scheduleId,
      'slot_date': _dateToJson(instance.slotDate),
      'slot_start': _timeToJson(instance.startTime),
      'slot_end': _timeToJson(instance.endTime),
      'is_booked': instance.isBooked,
      'created_at': instance.createdAt?.toIso8601String(),
    };
