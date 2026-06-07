import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/login_with_email_usecase.dart';
import '../../../domain/entity/user_entity.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final LoginWithEmailUseCase _loginWithEmail;

  SignInBloc(this._loginWithEmail) : super(const SignInInitial()) {
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInLoading());
    final result = await _loginWithEmail(event.email, event.password);
    switch (result) {
      case Success<UserEntity>():
        emit(SignInSuccess(result.data));
      case Failure<UserEntity>():
        emit(SignInFailure(result.message));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInLoading());
    // TODO(google): implement Google sign in
    emit(const SignInFailure('Google sign in coming soon'));
  }
}
