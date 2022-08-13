import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/core/classes/comment.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:uuid/uuid.dart';
import 'cubit.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitState());

  void getGalleryPosts(String userId) async {
    emit(PostLoading());
    try {
      List<Post>? listAllPosts = await app.getListNormalPost(userId);
      List<Post> listNonFeatured = [];
      for (var item in listAllPosts!) if (item.isFeatured == null || !item.isFeatured!) listNonFeatured.add(item);
      emit(PostLoaded(listPosts: listNonFeatured));
    } on Exception catch (e) {
      print("error getGalleryPosts: ${e.toString()}");
      emit(PostLoaded(listPosts: null));
    }
  }

  void getStory(String userId) async {
    emit(PostLoading());
    try {
      List<Post>? listPosts = await app.getListFeaturedPost(userId);
      emit(PostLoaded(listPosts: listPosts));
    } on Exception catch (e) {
      print("error getStory: ${e.toString()}");
      emit(PostLoaded(listPosts: null));
    }
  }

  void getPostsByUser(String userId) async {
    try {
      emit(PostLoading());
      List<Post>? listAll = await app.getAllPost(userId);
      List<Post>? listUserPosts = [];
      for (var item in listAll!) if (item.userId == userId) listUserPosts.add(item);

      // List<Like>? allLikes = await _api.getLikeByUser(userId);
      int postTotal = 0;
      int skillTotal = 0;
      int likeTotal = 0;
      if (listUserPosts != null) {
        for (Post post in listUserPosts) {
          // for (Like like in allLikes!) {
          //   if (like.postId == post.postId) {
          //     post.isUserLiked = true;
          //   }
          // }
          postTotal++;
          skillTotal += post.skillPoints ?? 0;
          likeTotal += post.likeCount;
        }
      }
      emit(ProfileLoaded(
        listPosts: listUserPosts,
        postTotal: postTotal,
        skillTotal: skillTotal,
        likeTotal: likeTotal,
      ));
    } on Exception catch (e) {
      print("error getPostsByUser: ${e.toString()}");
    }
  }

  void getPostsOfActivity(String activityId) async {
    emit(PostLoading());
    try {
      final Api _api = Api();
      List<Post>? relatedPosts = await _api.getPostByActivity(activityId);
      emit(PostLoaded(listPosts: relatedPosts));
    } on Exception catch (e) {
      print("error getPostsOfActivity: ${e.toString()}");
      emit(PostLoaded(listPosts: null));
    }
  }

  void uploadPost(Post post, File file) async {
    emit(PostLoading());
    try {
      post.uploadMediaType = post.pickedMedia!.type;
      final Api _api = Api();
      String? postId = await _api.savePost(post, file);
      // cache new published file
      // var oldFileBytes = await file.readAsBytes();
      // await Tool.cacheNewPublishedPost(postId!, oldFileBytes);
      // if picture is taken by camera. (Not from gallery)
      if (post.pickedMedia!.storageFile == null && await File(post.pickedMedia!.path!).exists()) {
        await File(post.pickedMedia!.path!).delete();
      }
      emit(PostInitState());
    } on Exception catch (e) {
      print("error uploadPost: ${e.toString()}");
    }
  }

  void getPostDetail(Post post) async {
    List<Comment>? listComment = await getComments(post);
    post.listComment = listComment;
    emit(PostDetail(post: post));
  }

  void likePost(Post post, String userId) {
    final Api _api = Api();
    if (!post.isUserLiked) {
      post.isUserLiked = true;
      post.likeCount = post.likeCount + 1;
      post.likedUserIds += userId + ";";
    } else {
      List<String> listLike = post.likedUserIds.split(";");
      if (listLike.contains(userId)) {
        post.isUserLiked = false;
        post.likeCount = post.likeCount - 1;
        listLike.remove(userId);
        post.likedUserIds = "";
        for (var item in listLike) post.likedUserIds += item;
      }
    }
    _api.updatePost(post);
    emit(PostDetail(post: post));
  }

  void addComment(String commentMessage, User user, String postId) {
    final Api _api = Api();
    Comment comment = new Comment();
    comment.commentId = Uuid().v4();
    comment.postId = postId;
    comment.userId = user.id;
    comment.userName = user.name;
    comment.userProfilePic = user.profile_pic;
    comment.userType = user.type;
    comment.comment = commentMessage;
    comment.date = DateTime.now();
    _api.postComment(comment);

    Post post = (state as PostDetail).post;
    if (post.listComment == null) post.listComment = [];
    post.listComment!.add(comment);
    post.commentCount++;
    _api.updatePost(post);
    emit(PostDetail(post: post));
  }

  Future<List<Comment>?> getComments(post) async {
    final Api _api = Api();
    return _api.getListComment(post.postId);
  }

  void deleteComment(String commentId) async {
    final Api _api = Api();
    await _api.deleteComment(commentId);
    Post post = (state as PostDetail).post;
    if (post.listComment != null) {
      post.listComment!.removeWhere((item) => item.commentId == commentId);
      post.commentCount--;
      _api.updatePost(post);
    }
    emit(PostDetail(post: post));
  }
}
