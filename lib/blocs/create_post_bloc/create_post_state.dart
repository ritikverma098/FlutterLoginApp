part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostState {}

class CreatePostInitial extends CreatePostState {}

class CreatePostFailure extends CreatePostState {}
class CreatePostLoading extends CreatePostState {}
class CreatePostSuccess extends CreatePostState {
  final Post post;
  CreatePostSuccess(this.post);
}