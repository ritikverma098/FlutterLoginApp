import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:post_rep/post_rep.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository _postRepository;
  CreatePostBloc({required PostRepository myPostRepository}) :
        _postRepository = myPostRepository,
        super(CreatePostInitial()) {
    on<CreatePost>((event, emit) async {
      emit(CreatePostLoading());
      try{
        Post post = await _postRepository.createPost(event.post);
        emit(CreatePostSuccess(post));
      }catch(e){
        emit(CreatePostFailure());
      }
    });
  }
}
