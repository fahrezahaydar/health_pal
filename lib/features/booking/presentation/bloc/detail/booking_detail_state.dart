// lib/features/booking/presentation/bloc/detail/booking_detail_state.dart

import 'package:equatable/equatable.dart';

import '../../../domain/entity/appointment_entity.dart';

sealed class BookingDetailState extends Equatable {
  const BookingDetailState();
  @override
  List<Object?> get props => [];
}

class BookingDetailInitial extends BookingDetailState {
  const BookingDetailInitial();
}

class BookingDetailLoading extends BookingDetailState {
  const BookingDetailLoading();
}

class BookingDetailLoaded extends BookingDetailState {
  final AppointmentEntity appointment;
  final bool isCancelling;

  const BookingDetailLoaded({
    required this.appointment,
    this.isCancelling = false,
  });

  BookingDetailLoaded copyWith({
    AppointmentEntity? appointment,
    bool? isCancelling,
  }) =>
      BookingDetailLoaded(
        appointment: appointment ?? this.appointment,
        isCancelling: isCancelling ?? this.isCancelling,
      );

  @override
  List<Object?> get props => [appointment, isCancelling];
}

class BookingDetailError extends BookingDetailState {
  final String message;
  const BookingDetailError({this.message = ''});

  @override
  List<Object?> get props => [message];
}
