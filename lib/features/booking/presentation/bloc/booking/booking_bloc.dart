// lib/features/booking/presentation/bloc/booking/booking_bloc.dart
//
// Event-driven bloc untuk Book Appointment page.
// - Initialized → load slots untuk doctor + date
// - DateSelected → refetch slots untuk date baru
// - SlotSelected → set slotId + start/end time
// - Submitted → POST ke create-appointment Edge Function
// - Reset → clear state
//
// Gunakan GetDoctorSlotsUseCase untuk fetch slot (reuse dari doctor feature).
// Gunakan CreateAppointmentUseCase untuk submit.

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../doctor/domain/usecase/get_doctor_slots_usecase.dart';
import '../../../domain/usecase/create_appointment_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

@injectable
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetDoctorSlotsUseCase _getSlots;
  final CreateAppointmentUseCase _createAppointment;

  BookingBloc(this._getSlots, this._createAppointment)
      : super(const BookingState()) {
    on<BookingInitialized>(_onInitialized);
    on<BookingDateSelected>(_onDateSelected);
    on<BookingSlotSelected>(_onSlotSelected);
    on<BookingSubmitted>(_onSubmitted);
    on<BookingReset>(_onReset);
  }

  Future<void> _onInitialized(
    BookingInitialized event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(
      doctorId: event.doctorId,
      selectedDate: event.selectedDate,
      isLoadingSlots: true,
      clearError: true,
    ));
    await _loadSlots(event.doctorId, event.selectedDate, emit);
  }

  Future<void> _onDateSelected(
    BookingDateSelected event,
    Emitter<BookingState> emit,
  ) async {
    if (state.doctorId == null) return;
    emit(state.copyWith(
      selectedDate: event.date,
      selectedSlotId: null,
      slotStartTime: null,
      slotEndTime: null,
      isLoadingSlots: true,
      clearError: true,
    ));
    await _loadSlots(state.doctorId!, event.date, emit);
  }

  void _onSlotSelected(
    BookingSlotSelected event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(
      selectedSlotId: event.slotId,
      slotStartTime: event.startTime,
      slotEndTime: event.endTime,
      clearError: true,
    ));
  }

  Future<void> _onSubmitted(
    BookingSubmitted event,
    Emitter<BookingState> emit,
  ) async {
    if (state.selectedSlotId == null || state.doctorId == null) {
      emit(state.copyWith(errorMessage: 'Pilih slot terlebih dahulu'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _createAppointment(
      doctorId: state.doctorId!,
      slotId: state.selectedSlotId!,
      complaintNote: event.complaintNote,
    );

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          isSubmitting: false,
          createdAppointment: data,
        ));
      case Failure(:final message):
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: message,
        ));
    }
  }

  void _onReset(BookingReset event, Emitter<BookingState> emit) {
    emit(const BookingState());
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _loadSlots(
    String doctorId,
    DateTime? date,
    Emitter<BookingState> emit,
  ) async {
    final queryDate = date ?? DateTime.now();
    final result = await _getSlots(doctorId, queryDate);
    switch (result) {
      case Success(:final data):
        final slots = data
            .map((e) => {
                  'id': e.id,
                  'startTime': e.startTimeDisplay,
                  'endTime': _formatTime(e.endTime),
                })
            .toList();
        emit(state.copyWith(
          isLoadingSlots: false,
          availableSlots: slots,
        ));
      case Failure(:final message):
        emit(state.copyWith(
          isLoadingSlots: false,
          errorMessage: message,
        ));
    }
  }
}
