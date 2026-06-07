import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ForgotPasswordStep { initial, verify, newPassword }

class ForgotPasswordCubit extends Cubit<ForgotPasswordStep> {
  ForgotPasswordCubit() : super(ForgotPasswordStep.initial);

  Future<void> sendEmail(
    String email, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
    onSuccess?.call('Verification code sent to $email');
    emit(ForgotPasswordStep.verify);
  }

  Future<void> verifyCode(
    String code, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
    onSuccess?.call('Code verified successfully');
    emit(ForgotPasswordStep.newPassword);
  }

  Future<void> resetPassword(
    String password, {
    ValueSetter<String>? onError,
    ValueSetter<String>? onSuccess,
  }) async {
    await Future.delayed(const Duration(seconds: 5));
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
