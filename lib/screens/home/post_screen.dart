import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_social/blocs/create_post_bloc/create_post_bloc.dart';
import 'package:login_social/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:post_rep/post_rep.dart';
import 'package:user_rep/user_rep.dart';

class PostScreen extends StatefulWidget {
  final MyUser myUser;
  const PostScreen(this.myUser, {super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post post;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    log(post.toString());
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess){
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: GestureDetector(
            onTap: (){
              if(_controller.text.isNotEmpty){

                setState(() {
                  post.post = _controller.text;
                });
                context.read<CreatePostBloc>().add(CreatePost(post));
              }
            },
            child: Container(
              width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(2.0,2.0),
                      blurRadius: 2.0
                    )
                  ]
                ),

                child: const Icon(CupertinoIcons.add)),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: const Center(
              child: Text(
                "Create a Post"
              ),
            ),

          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                maxLines: 10,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: "Enter Your Post here...",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.orange,style: BorderStyle.solid)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:  BorderSide(color: Theme.of(context).colorScheme.primaryContainer,style: BorderStyle.solid)
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
);
  }
}
