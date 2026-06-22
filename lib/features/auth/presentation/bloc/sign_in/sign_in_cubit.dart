import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/login_with_email_usecase.dart';
import '../../../domain/entity/user_entity.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final LoginWithEmailUseCase _loginWithEmail;

  SignInCubit(this._loginWithEmail) : super(const SignInInitial());

  Future<void> signInWithEmail(String email, String password) async {
    emit(const SignInLoading());
    final result = await _loginWithEmail(email, password);

    switch (result) {
      case Success<UserEntity>():
        emit(SignInSuccess(result.data));
      case Failure<UserEntity>():
        emit(SignInFailure(result.message));
    }
  }

  void signInWithGoogle() {
    emit(const SignInLoading());
    emit(const SignInFailure('Google sign in coming soon'));
  }
}
