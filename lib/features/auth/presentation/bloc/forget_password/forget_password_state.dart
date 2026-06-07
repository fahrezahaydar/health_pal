import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/forgot_password_usecase.dart';

enum ForgotPasswordStep { initial, verify, newPassword }

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordStep> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit(this._forgotPasswordUseCase)
      : super(ForgotPasswordStep.initial);

  Future<void> sendEmail(
    String email, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    final result = await _forgotPasswordUseCase(email);
    switch (result) {
      case Success<void>():
        onSuccess?.call('Reset link sent to $email');
        emit(ForgotPasswordStep.verify);
      case Failure<void>():
        onError?.call(result.message);
    }
  }

  Future<void> verifyCode(
    String code, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    onSuccess?.call('Code verified successfully');
    emit(ForgotPasswordStep.newPassword);
  }

  Future<void> resetPassword(
    String password, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    onSuccess?.call('Password reset successfully');
  }

  void back() {
    switch (state) {
      case ForgotPasswordStep.initial:
        break;
      case ForgotPasswordStep.verify:
        emit(ForgotPasswordStep.initial);
        break;
      case ForgotPasswordStep.newPassword:
        emit(ForgotPasswordStep.verify);
        break;
    }
  }
}
