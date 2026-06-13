// lib/features/booking/presentation/bloc/booking/booking_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/appointment_entity.dart';

class BookingState extends Equatable {
  final String? doctorId;
  final DateTime? selectedDate;
  final String? selectedSlotId;
  final String? slotStartTime;
  final String? slotEndTime;
  final bool isLoadingSlots;
  final List<Map<String, dynamic>> availableSlots; // raw slot data
  final bool isSubmitting;
  final AppointmentEntity? createdAppointment;
  final String? errorMessage;

  const BookingState({
    this.doctorId,
    this.selectedDate,
    this.selectedSlotId,
    this.slotStartTime,
    this.slotEndTime,
    this.isLoadingSlots = false,
    this.availableSlots = const [],
    this.isSubmitting = false,
    this.createdAppointment,
    this.errorMessage,
  });

  /// True if slot sudah dipilih dan bisa submit.
  bool get canSubmit =>
      selectedSlotId != null && !isSubmitting && !isLoadingSlots;

  BookingState copyWith({
    String? doctorId,
    DateTime? selectedDate,
    String? selectedSlotId,
    String? slotStartTime,
    String? slotEndTime,
    bool? isLoadingSlots,
    List<Map<String, dynamic>>? availableSlots,
    bool? isSubmitting,
    AppointmentEntity? createdAppointment,
    String? errorMessage,
    bool clearError = false,
    bool clearCreated = false,
  }) {
    return BookingState(
      doctorId: doctorId ?? this.doctorId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotId: selectedSlotId ?? this.selectedSlotId,
      slotStartTime: slotStartTime ?? this.slotStartTime,
      slotEndTime: slotEndTime ?? this.slotEndTime,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      createdAppointment:
          clearCreated ? null : (createdAppointment ?? this.createdAppointment),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        doctorId,
        selectedDate,
        selectedSlotId,
        slotStartTime,
        slotEndTime,
        isLoadingSlots,
        availableSlots,
        isSubmitting,
        createdAppointment,
        errorMessage,
      ];
}
