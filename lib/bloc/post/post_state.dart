import 'package:sillyhouseorg/core/classes/post.dart';

abstract class PostState {}

class PostInitState extends PostState {}

class PostLoading extends PostState {}

class PostErrorState extends PostState {
  String errorMessage;

  PostErrorState({required this.errorMessage});
}

class PostHomeLoaded extends PostState {
  List<Post>? listPost;
  List<Post>? listFeaturedPost;
  bool isLoading = false;

  PostHomeLoaded({this.listPost, this.listFeaturedPost, this.isLoading = false});

  PostHomeLoaded copyWith({List<Post>? listPost, List<Post>? listFeaturedPost, bool? isLoading = false}) {
    return PostHomeLoaded(
      listPost: listPost ?? this.listPost,
      listFeaturedPost: listFeaturedPost ?? this.listFeaturedPost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [listPost, listFeaturedPost, isLoading];
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
