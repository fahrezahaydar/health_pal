// lib/features/booking/presentation/bloc/history/booking_history_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/appointment_entity.dart';

sealed class BookingHistoryState extends Equatable {
  const BookingHistoryState();
  @override
  List<Object?> get props => [];
}

class BookingHistoryInitial extends BookingHistoryState {
  const BookingHistoryInitial();
}

class BookingHistoryLoading extends BookingHistoryState {
  const BookingHistoryLoading();
}

class BookingHistoryLoaded extends BookingHistoryState {
  final List<AppointmentEntity> appointments;
  final String? activeStatus; // null = "Semua"
  final bool hasMore;

  const BookingHistoryLoaded({
    this.appointments = const [],
    this.activeStatus,
    this.hasMore = false,
  });

  BookingHistoryLoaded copyWith({
    List<AppointmentEntity>? appointments,
    String? activeStatus,
    bool? hasMore,
  }) =>
      BookingHistoryLoaded(
        appointments: appointments ?? this.appointments,
        activeStatus: activeStatus ?? this.activeStatus,
        hasMore: hasMore ?? this.hasMore,
      );

  @override
  List<Object?> get props => [appointments, activeStatus, hasMore];
}

class BookingHistoryError extends BookingHistoryState {
  final String message;
  const BookingHistoryError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
