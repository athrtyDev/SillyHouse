import 'package:sillyhouseorg/core/classes/like.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileModel extends BaseModel {
  final Api? _api = locator<Api>();
  List<Post>? listUserAllPosts;
  late User loggedUser;
  List<Like>? allLikes;

  void loadPostsByUser(BuildContext context) async {
    setState(ViewState.Busy);
    loggedUser = Provider.of<User>(context, listen: false);
    listUserAllPosts = await _api!.getPostByUser(loggedUser);
    allLikes = await _api!.getAllLikes();
    // count Post, skill, like
    int postTotal = 0;
    int skillTotal = 0;
    int likeTotal = 0;
    if (listUserAllPosts != null) {
      for (Post post in listUserAllPosts!) {
        for (Like like in allLikes!) {
          // Count every post's like
          if (like.postId == post.postId) {
            if (post.likeCount == null) post.likeCount = 0;
            post.likeCount = post.likeCount! + 1;
          }
          // Check if logged user liked the post
          if (post.isUserLiked == null) post.isUserLiked = false;
          if (like.postId == post.postId && like.likedUserId == loggedUser.id) {
            post.isUserLiked = true;
          }
        }
        postTotal++;
        skillTotal += post.skillPoints ?? 0;
        likeTotal += post.likeCount ?? 0;
      }
    }
    loggedUser.postTotal = postTotal;
    loggedUser.skillTotal = skillTotal;
    loggedUser.likeTotal = likeTotal;
    setState(ViewState.Idle);
    notifyListeners();
  }

  void likePost(Post post) {
    post.isUserLiked = true;
    post.likeCount = post.likeCount ?? 0;
    loggedUser.likeTotal = loggedUser.likeTotal ?? 0;
    post.likeCount = post.likeCount! + 1;
    loggedUser.likeTotal = loggedUser.likeTotal! + 1;
    _api!.likePost(post, loggedUser.id);
    notifyListeners();
  }

  void dislikePost(Post post) {
    post.isUserLiked = false;
    post.likeCount = post.likeCount! - 1;
    loggedUser.likeTotal = loggedUser.likeTotal! - 1;
    _api!.dislikePost(post, loggedUser.id);
    notifyListeners();
  }
}
