import 'package:equatable/equatable.dart';

import '../../../domain/entity/user_entity.dart';

sealed class SignInState extends Equatable {
  const SignInState();
}

final class SignInInitial extends SignInState {
  const SignInInitial();

  @override
  List<Object?> get props => [];
}

final class SignInLoading extends SignInState {
  const SignInLoading();

  @override
  List<Object?> get props => [];
}

final class SignInSuccess extends SignInState {
  final UserEntity user;

  const SignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class SignInFailure extends SignInState {
  final String message;

  const SignInFailure(this.message);

  @override
  List<Object?> get props => [message];
}
