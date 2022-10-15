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

  static const int postFetchCount = 3;
  bool fetchedAllPost = false;
  final Api api = Api();

  void initHomePost(String userId) async {
    emit(PostLoading());
    try {
      List<Post>? listPost = await api.getPostPagination(postFetchCount);
      List<Post>? listFeatured = await api.getFeaturedPost();
      emit(PostHomeLoaded(listPost: listPost, listFeaturedPost: listFeatured));
    } catch (e) {
      print("error home initHomePost: ${e.toString()}");
      emit(PostHomeLoaded(listPost: null));
    }
  }

  void moreHomePost() async {
    if (fetchedAllPost || (state as PostHomeLoaded).listPost == null) return;
    emit((state as PostHomeLoaded).copyWith(isLoading: true));
    try {
      List<Post>? listNewPost = await api.getPostPagination(postFetchCount);
      if (listNewPost == null) {
        fetchedAllPost = true;
        emit((state as PostHomeLoaded).copyWith(isLoading: false));
      } else {
        emit((state as PostHomeLoaded).copyWith(isLoading: false, listPost: (state as PostHomeLoaded).listPost! + listNewPost));
      }
    } catch (e) {
      print("error home initHomePost: ${e.toString()}");
      emit((state as PostHomeLoaded).copyWith(isLoading: false));
    }
  }

  void likeHomePost(Post post, String userId) {
    Post newPost = likePost(post, userId);
    List<Post> listPost = (state as PostHomeLoaded).listPost!;
    for (int i = 0; i < listPost.length; i++) {
      if (listPost[i].postId == post.postId) {
        listPost[i] = newPost;
        break;
      }
    }
    emit((state as PostHomeLoaded).copyWith(listPost: listPost));
  }

  void updateHomePost(Post updatedPost) {
    List<Post> listPost = (state as PostHomeLoaded).listPost!;
    for (int i = 0; i < listPost.length; i++) {
      if (listPost[i].postId == updatedPost.postId) {
        listPost[i] = updatedPost;
        break;
      }
    }
    emit((state as PostHomeLoaded).copyWith(listPost: listPost));
  }

  void likePostDetailPost(Post post, String userId) {
    Post newPost = likePost(post, userId);
    emit(PostDetail(post: newPost));
  }

  // void getGalleryPosts(String userId) async {
  //   emit(PostLoading());
  //   try {
  //     List<Post>? listAllPosts = await app.getListNormalPost(userId);
  //     List<Post> listNonFeatured = [];
  //     for (var item in listAllPosts!) if (item.isFeatured == null || !item.isFeatured!) listNonFeatured.add(item);
  //     emit(PostLoaded(listPosts: listNonFeatured));
  //   } on Exception catch (e) {
  //     print("error getGalleryPosts: ${e.toString()}");
  //     emit(PostLoaded(listPosts: null));
  //   }
  // }
  //
  // void getStory(String userId) async {
  //   emit(PostLoading());
  //   try {
  //     List<Post>? listPosts = await app.getListFeaturedPost(userId);
  //     emit(PostLoaded(listPosts: listPosts));
  //   } on Exception catch (e) {
  //     print("error getStory: ${e.toString()}");
  //     emit(PostLoaded(listPosts: null));
  //   }
  // }

  void getPostsByUser(String userId) async {
    try {
      emit(PostLoading());
      List<Post>? listUserPosts = await api.getPostByUser(userId);
      int postTotal = 0;
      int skillTotal = 0;
      int likeTotal = 0;
      if (listUserPosts != null) {
        for (Post post in listUserPosts) {
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
      List<Post>? relatedPosts = await api.getPostByActivity(activityId);
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
      post.isSelfie = post.pickedMedia!.isSelfie != null && post.pickedMedia!.isSelfie!;
      Post? uploadedPost = await api.savePost(post, file);

      if (uploadedPost != null) {
        // Add to cache
        if (app.allPost == null) {
          List<Post> list = [uploadedPost];
          app.allPost = list;
        } else {
          app.allPost!.insert(0, uploadedPost);
        }
        emit(PostUploadSuccess());
      } else {
        emit(PostErrorState(errorMessage: "Алдаа гарлаа"));
      }
    } on Exception catch (e) {
      print("error uploadPost: ${e.toString()}");
    }
  }

  void getPostDetail(Post post) async {
    emit(PostDetail(post: post));
    List<Comment>? listComment = await getComments(post.postId!);
    post.listComment = listComment;
    emit(PostDetail(post: post));
  }

  Post likePost(Post post, String userId) {
    if (!post.isUserLiked) {
      post.isUserLiked = true;
      post.likeCount = post.likeCount + 1;
      post.likedUserIds += ";" + userId;
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
    api.updatePost(post);
    return post;
  }

  void addComment(String commentMessage, User user, String postId) {
    Comment comment = new Comment();
    comment.commentId = Uuid().v4();
    comment.postId = postId;
    comment.userId = user.id;
    comment.userName = user.name;
    comment.userProfilePic = user.profile_pic;
    comment.userType = user.type;
    comment.comment = commentMessage;
    comment.date = DateTime.now();
    api.postComment(comment);

    Post post = (state as PostDetail).post;
    if (post.listComment == null) post.listComment = [];
    post.listComment!.add(comment);
    post.commentCount++;
    api.updatePost(post);
    emit(PostDetail(post: post));
  }

  Future<List<Comment>?> getComments(String postId) async {
    return api.getListComment(postId);
  }

  void deleteComment(String commentId) async {
    await api.deleteComment(commentId);
    Post post = (state as PostDetail).post;
    if (post.listComment != null) {
      post.listComment!.removeWhere((item) => item.commentId == commentId);
      post.commentCount--;
      api.updatePost(post);
    }
    emit(PostDetail(post: post));
  }
}
