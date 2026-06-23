import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/network/result.dart';
import '../../../../auth/domain/usecase/register_and_create_profile_usecase.dart';
import '../../../domain/entity/user_entity.dart';

part 'create_profile_state.dart';

class CreateProfileArgs {
  final String fullName;
  final String email;
  final String password;

  const CreateProfileArgs({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

@injectable
class CreateProfileCubit extends Cubit<CreateProfileState> {
  final RegisterAndCreateProfileUseCase _create;
  final String _password;

  CreateProfileCubit(this._create, @factoryParam CreateProfileArgs args)
    : _password = args.password,
      super(
        CreateProfileState(
          fullName: args.fullName,
          email: args.email,
          dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 20)),
        ),
      );

  Future<void> register() async {
    emit(state.copyWith(status: CubitStatus.loading));
    final result = await _create(
      email: state.email,
      password: _password,
      fullName: state.fullName,
      nickname: state.nickname,
      gender: state.gender,
      dateOfBirth: state.dateOfBirth,
      photo: state.photo,
    );
    switch (result) {
      case Success<UserEntity>():
        emit(state.copyWith(status: CubitStatus.success, user: result.data));
      case Failure<UserEntity>():
        emit(
          state.copyWith(
            status: CubitStatus.failure,
            errorMessage: result.message,
          ),
        );
    }
  }

  void updateFullName(String value) {
    emit(state.copyWith(fullName: value));
  }

  void updateNickname(String value) {
    emit(state.copyWith(nickname: value));
  }

  void updateGender(String value) {
    emit(state.copyWith(gender: value));
  }

  void updateEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void updateDateOfBirth(DateTime value) {
    emit(state.copyWith(dateOfBirth: value));
  }

  void updatePhoto(File? value) {
    emit(state.copyWith(photo: value));
  }
}
