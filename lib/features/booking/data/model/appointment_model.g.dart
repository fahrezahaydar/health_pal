// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    _AppointmentModel(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      slotId: json['slot_id'] as String,
      status: json['status'] as String,
      complaintNote: json['complaint_note'] as String?,
      consultationFeeSnapshot: (json['consultation_fee_snapshot'] as num)
          .toDouble(),
      bookedAt: json['booked_at'] == null
          ? null
          : DateTime.parse(json['booked_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      doctors: json['doctors'] == null
          ? null
          : AppointmentDoctorModel.fromJson(
              json['doctors'] as Map<String, dynamic>,
            ),
      doctorSlots: json['doctor_slots'] == null
          ? null
          : AppointmentSlotModel.fromJson(
              json['doctor_slots'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AppointmentModelToJson(_AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
      'slot_id': instance.slotId,
      'status': instance.status,
      'complaint_note': instance.complaintNote,
      'consultation_fee_snapshot': instance.consultationFeeSnapshot,
      'booked_at': instance.bookedAt?.toIso8601String(),
      'confirmed_at': instance.confirmedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'cancellation_reason': instance.cancellationReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'doctors': instance.doctors,
      'doctor_slots': instance.doctorSlots,
    };

_AppointmentDoctorModel _$AppointmentDoctorModelFromJson(
  Map<String, dynamic> json,
) => _AppointmentDoctorModel(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  photoUrl: json['photo_url'] as String?,
  experienceYears: (json['experience_years'] as num?)?.toInt(),
  specializations: json['specializations'] == null
      ? null
      : AppointmentSpecializationModel.fromJson(
          json['specializations'] as Map<String, dynamic>,
        ),
  clinics: json['clinics'] == null
      ? null
      : AppointmentClinicModel.fromJson(
          json['clinics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AppointmentDoctorModelToJson(
  _AppointmentDoctorModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'photo_url': instance.photoUrl,
  'experience_years': instance.experienceYears,
  'specializations': instance.specializations,
  'clinics': instance.clinics,
};

_AppointmentSpecializationModel _$AppointmentSpecializationModelFromJson(
  Map<String, dynamic> json,
) => _AppointmentSpecializationModel(name: json['name'] as String);

Map<String, dynamic> _$AppointmentSpecializationModelToJson(
  _AppointmentSpecializationModel instance,
) => <String, dynamic>{'name': instance.name};

_AppointmentClinicModel _$AppointmentClinicModelFromJson(
  Map<String, dynamic> json,
) => _AppointmentClinicModel(
  name: json['name'] as String,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$AppointmentClinicModelToJson(
  _AppointmentClinicModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'phone': instance.phone,
};

_AppointmentSlotModel _$AppointmentSlotModelFromJson(
  Map<String, dynamic> json,
) => _AppointmentSlotModel(
  slotDate: _dateFromJson(json['slot_date']),
  slotStart: _timeFromJson(json['slot_start']),
  slotEnd: _timeFromJson(json['slot_end']),
);

Map<String, dynamic> _$AppointmentSlotModelToJson(
  _AppointmentSlotModel instance,
) => <String, dynamic>{
  'slot_date': _dateToJson(instance.slotDate),
  'slot_start': _timeToJson(instance.slotStart),
  'slot_end': _timeToJson(instance.slotEnd),
};
