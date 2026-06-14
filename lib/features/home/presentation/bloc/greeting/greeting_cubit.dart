import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../domain/entity/user_profile_entity.dart';
import '../../../domain/usecase/get_user_profile_usecase.dart';
import 'greeting_state.dart';

@injectable
class GreetingCubit extends Cubit<GreetingState> {
  final GetUserProfileUseCase _getUserProfile;

  GreetingCubit(this._getUserProfile) : super(const GreetingInitial());

  Future<String?> loadProfile(String authId) async {
    emit(const GreetingLoading());
    final result = await _getUserProfile(authId);
    switch (result) {
      case Success<UserProfileEntity>():
        emit(GreetingLoaded(
          nickname: result.data.nickname,
          profileId: result.data.id,
          isProfileComplete: result.data.isProfileComplete,
        ));
        return result.data.id;
      case Failure<UserProfileEntity>():
        emit(GreetingError(message: result.message));
        return null;
    }
  }
}
