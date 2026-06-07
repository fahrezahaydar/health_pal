import 'package:equatable/equatable.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

final class SignInWithEmail extends SignInEvent {
  final String email;
  final String password;

  const SignInWithEmail(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class SignInWithGoogle extends SignInEvent {
  const SignInWithGoogle();

  @override
  List<Object> get props => [];
}
