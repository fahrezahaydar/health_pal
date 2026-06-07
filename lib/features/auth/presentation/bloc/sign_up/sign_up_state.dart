import 'package:equatable/equatable.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();

  @override
  List<Object?> get props => [];
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();

  @override
  List<Object?> get props => [];
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess();

  @override
  List<Object?> get props => [];
}

final class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}
