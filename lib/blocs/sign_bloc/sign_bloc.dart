import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:user_rep/user_rep.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final UserRepository _userRepository;

  SignBloc({
    required UserRepository userRepository
}) : _userRepository = userRepository,
  super(SignInInitial()) {
    on<SignInRequired>((event, emit) async{
      emit(SignInProgress());
      try{
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      }catch(e){
        log(e.toString());
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired> ((event,emit) async{
      await _userRepository.logout();
    });
  }
}
