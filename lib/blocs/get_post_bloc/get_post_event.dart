part of 'get_post_bloc.dart';

@immutable
abstract class GetPostEvent extends Equatable{
  const GetPostEvent();

  @override
  List<Object> get props =>[];
}

class GetPosts extends GetPostEvent{}