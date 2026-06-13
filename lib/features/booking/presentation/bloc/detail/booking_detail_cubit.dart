// lib/features/booking/presentation/bloc/detail/booking_detail_cubit.dart
//
// Cubit untuk Booking Detail page.
// - loadDetail → fetch from API
// - cancelAppointment → call Edge Function, update state on success

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/usecase/cancel_appointment_usecase.dart';
import '../../../domain/usecase/get_appointment_detail_usecase.dart';
import 'booking_detail_state.dart';

@injectable
class BookingDetailCubit extends Cubit<BookingDetailState> {
  final GetAppointmentDetailUseCase _getDetail;
  final CancelAppointmentUseCase _cancel;

  BookingDetailCubit(this._getDetail, this._cancel)
      : super(const BookingDetailInitial());

  Future<void> loadDetail({
    required String patientId,
    required String appointmentId,
  }) async {
    emit(const BookingDetailLoading());

    final result = await _getDetail(
      patientId: patientId,
      appointmentId: appointmentId,
    );

    switch (result) {
      case Success(:final data):
        emit(BookingDetailLoaded(appointment: data));
      case Failure(:final message):
        emit(BookingDetailError(message: message));
    }
  }

  Future<void> cancelAppointment({
    required String appointmentId,
    String? cancellationReason,
  }) async {
    final current = state;
    if (current is! BookingDetailLoaded) return;
    emit(current.copyWith(isCancelling: true));

    final result = await _cancel(
      appointmentId: appointmentId,
      cancellationReason: cancellationReason,
    );

    switch (result) {
      case Success(:final data):
        emit(BookingDetailLoaded(appointment: data));
      case Failure(:final message):
        emit(BookingDetailError(message: message));
    }
  }
}
