import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/upcoming_appointment_entity.dart';
import '../../../domain/usecase/get_upcoming_appointment_usecase.dart';
import 'upcoming_state.dart';

@injectable
class UpcomingCubit extends Cubit<UpcomingState> {
  final GetUpcomingAppointmentUseCase _getUpcoming;

  UpcomingCubit(this._getUpcoming) : super(const UpcomingInitial());

  Future<void> loadUpcoming(String profileId) async {
    emit(const UpcomingLoading());
    final result = await _getUpcoming(profileId);
    switch (result) {
      case Success<UpcomingAppointmentEntity?>():
        emit(UpcomingLoaded(upcoming: result.data));
      case Failure<UpcomingAppointmentEntity?>():
        emit(UpcomingError(message: result.message));
    }
  }
}
