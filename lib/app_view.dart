
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_social/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:login_social/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:login_social/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:login_social/blocs/sign_bloc/sign_bloc.dart';
import 'package:login_social/screens/home/home_sceen.dart';
import 'package:login_social/screens/authentication/welcome_screen.dart';
import 'package:post_rep/post_rep.dart';

import 'blocs/update_user_info_bloc/update_user_info_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "IstaX",
        theme: ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true,
          brightness: Brightness.light
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          brightness: Brightness.dark,
          useMaterial3: true
        ),
        home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          builder:(context,state) {
            if(state.status == AuthenticationStatus.authenticated){
              return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context)=>SignBloc(
                            userRepository:
                            context.read<AuthenticationBloc>().userRepository)),
                    BlocProvider(create: (context)=> UpdateUserInfoBloc(
                        userRepository:
                        context.read<AuthenticationBloc>().userRepository
                    )),
                    BlocProvider(
                        create: (
                            context)=>MyUserBloc(
                            myUserRepository:
                            context.read<AuthenticationBloc>().userRepository)
                          ..add(GetMyUser(
                              myUserId: context.read<AuthenticationBloc>().state.user!.uid)),
                    ),
                    BlocProvider(
                        create: (context) => GetPostBloc(postRepository: FirebasePostRepository())
                    ..add(GetPosts()))
                  ],
                  child: const HomeScreen());

            }
            else
              {
                return const WelcomeScreen();
              }
          },
        ),
      );
    },);
  }
}
