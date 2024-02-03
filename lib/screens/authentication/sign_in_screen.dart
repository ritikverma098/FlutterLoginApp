import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_social/components/textfield.dart';

import '../../blocs/sign_bloc/sign_bloc.dart';
import '../../components/strings.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignBloc, SignState>(
      listener: (context, state) {
        if(state is SignInSuccess){
          setState(() {
            signInRequired = false;
          });
        }else if (state is SignInProgress){
          setState(() {
            signInRequired = true;
          });
        }else if (state is SignInFailure){
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid Email and Password';
          });
        }
        },
      child: Form(
        key:_formKey,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail,color: Colors.orange,),
                errorMsg: _errorMsg,
                validator: (val) {
                  if(val!.isEmpty){
                    return 'Please Fill in the Field';
                  }else if (!emailRexExp.hasMatch(val)){
                    return 'Please enter a valid Email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(Icons.lock,color: Colors.orange,),
                errorMsg: _errorMsg,
                validator: (val) {
                  if(val!.isEmpty){
                    return 'Please Fill in the Field';
                  }else if (!passwordRexExp.hasMatch(val)){
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      obscurePassword = !obscurePassword;
                      if(obscurePassword){
                        iconPassword = CupertinoIcons.eye_fill;
                      }
                      else{
                        iconPassword = CupertinoIcons.eye_slash_fill;
                      }
                    });
                  },
                  icon: Icon(iconPassword, color: Colors.orange,),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            !signInRequired
                ? SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: TextButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    context.read<SignBloc>().add(SignInRequired(
                      emailController.text,
                      passwordController.text,
                    ));
                  }
                },
                style: TextButton.styleFrom(
                  elevation: 3.0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)
                  )
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  child: Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            )
                :const CircularProgressIndicator()
          ],
        )),
);
  }
}
