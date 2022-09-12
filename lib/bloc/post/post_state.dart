import 'package:sillyhouseorg/core/classes/post.dart';

abstract class PostState {}

class PostInitState extends PostState {}

class PostLoading extends PostState {}

class PostErrorState extends PostState {
  String errorMessage;

  PostErrorState({required this.errorMessage});
}

class PostHomeLoaded extends PostState {
  List<Post>? listAllPost;
  List<Post>? listFeaturedPost;

  PostHomeLoaded({this.listAllPost, this.listFeaturedPost});

  PostHomeLoaded copyWith({List<Post>? listAllPost, List<Post>? listFeaturedPost}) {
    return PostHomeLoaded(
      listAllPost: listAllPost ?? this.listAllPost,
      listFeaturedPost: listFeaturedPost ?? this.listFeaturedPost,
    );
  }

  @override
  List<Object?> get props => [listAllPost, listFeaturedPost];
}

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

class PostUploadSuccess extends PostState {}
