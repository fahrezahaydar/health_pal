import 'package:equatable/equatable.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

final class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  const SignUpSubmitted(this.name, this.email, this.password);

  @override
  List<Object> get props => [name, email, password];

  @override
  String toString() =>
      'SignUpSubmitted(name: $name, email: $email, password: [redacted])';
}
