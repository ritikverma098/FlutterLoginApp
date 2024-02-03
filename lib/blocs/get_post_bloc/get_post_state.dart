part of 'get_post_bloc.dart';

@immutable
abstract class GetPostState {}

class GetPostInitial extends GetPostState {}

class GetPostFailure extends GetPostState {}
class GetPostLoading extends GetPostState {}
class GetPostSuccess extends GetPostState {
  final List<Post> posts;
  GetPostSuccess(this.posts);
}
