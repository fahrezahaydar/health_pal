import '../../domain/entity/upcoming_appointment_entity.dart';

class UpcomingAppointmentModel {
  final String id;
  final String doctorName;
  final String? doctorPhoto;
  final String clinicName;
  final String specializationName;
  final String slotDate;
  final String slotStart;
  final String slotEnd;
  final String status;

  const UpcomingAppointmentModel({
    required this.id,
    required this.doctorName,
    this.doctorPhoto,
    required this.clinicName,
    required this.specializationName,
    required this.slotDate,
    required this.slotStart,
    required this.slotEnd,
    required this.status,
  });

  factory UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) {
    final doctors = json['doctors'] as Map<String, dynamic>?;
    final slots = json['doctor_slots'] as Map<String, dynamic>?;

    final clinics = doctors?['clinics'] as Map<String, dynamic>?;
    final specializations =
        doctors?['specializations'] as Map<String, dynamic>?;

    return UpcomingAppointmentModel(
      id: json['id'] as String,
      doctorName: doctors?['full_name'] as String? ?? '',
      doctorPhoto: doctors?['photo_url'] as String?,
      clinicName: clinics?['name'] as String? ?? '',
      specializationName: specializations?['name'] as String? ?? '',
      slotDate: slots?['slot_date'] as String? ?? '',
      slotStart: slots?['slot_start'] as String? ?? '',
      slotEnd: slots?['slot_end'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  UpcomingAppointmentEntity toEntity() => UpcomingAppointmentEntity(
        id: id,
        doctorName: doctorName,
        doctorPhoto: doctorPhoto,
        clinicName: clinicName,
        specializationName: specializationName,
        slotDate: slotDate,
        slotStart: slotStart,
        slotEnd: slotEnd,
        status: status,
      );
}
