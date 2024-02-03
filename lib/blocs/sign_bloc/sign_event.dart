part of 'sign_bloc.dart';

abstract class SignEvent extends Equatable {
  const SignEvent();

  @override
  List<Object> get props => [];
}
class SignInRequired extends SignEvent{
  final String email;
  final String password;

  const SignInRequired(this.email, this.password);
}

class SignOutRequired extends SignEvent{
  const SignOutRequired();
}