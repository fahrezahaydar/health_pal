// lib/features/booking/presentation/bloc/history/booking_history_cubit.dart
//
// Cubit untuk Booking History. Support:
// - filter by status (Semua / Pending / Upcoming / Completed / Cancelled)
// - pagination (loadMore)
// - pull-to-refresh (refresh)

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/usecase/get_appointment_history_usecase.dart';
import 'booking_history_state.dart';

@injectable
class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  final GetAppointmentHistoryUseCase _getHistory;

  String? _status;
  int _offset = 0;
  static const int _pageSize = 20;
  String? _patientId;
  bool _isLoadingMore = false;

  BookingHistoryCubit(this._getHistory) : super(const BookingHistoryInitial());

  /// Initial load + filter by status. `status == null` means "Semua".
  Future<void> loadHistory(String patientId, {String? status}) async {
    _patientId = patientId;
    _status = status;
    _offset = 0;
    emit(const BookingHistoryLoading());

    final result = await _getHistory(
      patientId: patientId,
      status: status,
      limit: _pageSize,
      offset: _offset,
    );

    switch (result) {
      case Success(:final data):
        _offset += data.length;
        for (var res in data) {
          if (res.slot == null) {
            print("Slot Null");
          }
        }
        emit(
          BookingHistoryLoaded(
            appointments: data,
            activeStatus: status,
            hasMore: data.length >= _pageSize,
          ),
        );
      case Failure(:final message):
        emit(BookingHistoryError(message: message));
    }
  }

  /// Filter by status (reset offset).
  Future<void> filterByStatus(String? status) async {
    if (_patientId == null) return;
    await loadHistory(_patientId!, status: status);
  }

  /// Append next page (infinite scroll).
  Future<void> loadMore() async {
    if (_patientId == null) return;
    if (_isLoadingMore) return;
    final current = state;
    if (current is! BookingHistoryLoaded || !current.hasMore) return;

    _isLoadingMore = true;
    final result = await _getHistory(
      patientId: _patientId!,
      status: _status,
      limit: _pageSize,
      offset: _offset,
    );
    _isLoadingMore = false;

    switch (result) {
      case Success(:final data):
        _offset += data.length;
        emit(
          current.copyWith(
            appointments: [...current.appointments, ...data],
            hasMore: data.length >= _pageSize,
          ),
        );
      case Failure(:final message):
        emit(BookingHistoryError(message: message));
    }
  }

  /// Pull-to-refresh: reload current filter dari awal.
  Future<void> refresh() async {
    if (_patientId == null) return;
    await loadHistory(_patientId!, status: _status);
  }
}
