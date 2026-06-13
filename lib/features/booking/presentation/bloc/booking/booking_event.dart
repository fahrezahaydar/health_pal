// lib/features/booking/presentation/bloc/booking/booking_event.dart

import 'package:equatable/equatable.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

/// Triggered when page opens. Load slots untuk tanggal & doctor tertentu.
class BookingInitialized extends BookingEvent {
  const BookingInitialized({
    required this.doctorId,
    this.selectedDate,
  });

  final String doctorId;
  final DateTime? selectedDate;

  @override
  List<Object?> get props => [doctorId, selectedDate];
}

/// Triggered saat user pilih tanggal berbeda. Refetch slots.
class BookingDateSelected extends BookingEvent {
  const BookingDateSelected(this.date);
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

/// Triggered saat user pilih slot waktu.
class BookingSlotSelected extends BookingEvent {
  const BookingSlotSelected({required this.slotId, this.startTime, this.endTime});

  final String slotId;
  final String? startTime; // "09:00"
  final String? endTime; // "09:30"

  @override
  List<Object?> get props => [slotId, startTime, endTime];
}

/// Triggered saat user tap "Konfirmasi Booking". Submit ke API.
class BookingSubmitted extends BookingEvent {
  const BookingSubmitted({this.complaintNote});

  final String? complaintNote;

  @override
  List<Object?> get props => [complaintNote];
}

/// Reset state (untuk back navigation).
class BookingReset extends BookingEvent {
  const BookingReset();
}
