import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/specialization_entity.dart';
import '../../../domain/usecase/get_specializations_usecase.dart';
import 'specialization_state.dart';

@injectable
class SpecializationCubit extends Cubit<SpecializationState> {
  final GetSpecializationsUseCase _getSpecializations;

  SpecializationCubit(this._getSpecializations) : super(const SpecializationInitial());

  Future<void> loadSpecializations() async {
    emit(const SpecializationLoading());
    final result = await _getSpecializations();
    switch (result) {
      case Success<List<SpecializationEntity>>():
        emit(SpecializationLoaded(specializations: result.data));
      case Failure<List<SpecializationEntity>>():
        emit(SpecializationError(message: result.message));
    }
  }
}
