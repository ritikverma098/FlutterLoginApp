part of 'sign_bloc.dart';

@immutable
abstract class SignState extends Equatable {
  const SignState();

  @override
  List<Object> get props =>[];
}

class SignInInitial extends SignState {}
class SignInSuccess extends SignState {}
class SignInFailure extends SignState {
  final String? message;

  const SignInFailure({this.message});
}

class SignInProgress extends SignState {}