import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/sign_up_usecase.dart';
import '../../../domain/entity/user_entity.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpBloc(this._signUpUseCase) : super(const SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    final result = await _signUpUseCase(event.email, event.password);
    switch (result) {
      case Success<UserEntity>():
        emit(const SignUpSuccess());
      case Failure<UserEntity>():
        emit(SignUpFailure(result.message));
    }
  }
}
