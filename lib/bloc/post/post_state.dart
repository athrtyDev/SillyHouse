import 'package:sillyhouseorg/core/classes/post.dart';

abstract class PostState {}

class PostInitState extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  List<Post>? listPosts;

  PostLoaded({this.listPosts});

  @override
  List<Object?> get props => [listPosts];
}

class ProfileLoaded extends PostState {
  List<Post>? listPosts;
  int postTotal;
  int skillTotal;
  int likeTotal;

  ProfileLoaded({
    this.listPosts,
    this.postTotal = 0,
    this.skillTotal = 0,
    this.likeTotal = 0,
  });

  @override
  List<Object?> get props => [listPosts, postTotal, skillTotal, likeTotal];
}

class PostDetail extends PostState {
  Post post;

  PostDetail({required this.post});

  @override
  List<Object?> get props => [post];
}
