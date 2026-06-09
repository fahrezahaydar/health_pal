import 'package:equatable/equatable.dart';

class UpcomingAppointmentEntity extends Equatable {
  final String id;
  final String doctorName;
  final String? doctorPhoto;
  final String clinicName;
  final String specializationName;
  final String slotDate;
  final String slotStart;
  final String slotEnd;
  final String status;

  const UpcomingAppointmentEntity({
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

  @override
  List<Object?> get props => [
        id,
        doctorName,
        doctorPhoto,
        clinicName,
        specializationName,
        slotDate,
        slotStart,
        slotEnd,
        status,
      ];
}
