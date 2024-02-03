import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_social/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_rep/user_rep.dart';

import 'app_view.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;

  const MainApp(this.userRepository, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationBloc>(
              create: (_) =>
                  AuthenticationBloc(
                      myUserRepository: userRepository))
        ],
        child: const MyAppView()
    );
  }
}