// import 'package:sillyhouseorg/core/classes/comment.dart';
// import 'package:sillyhouseorg/core/classes/like.dart';
// import 'package:sillyhouseorg/core/classes/post.dart';
// import 'package:sillyhouseorg/core/classes/user.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/services/api.dart';
// import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class GalleryModel extends BaseModel {
//   final Api? _api = Api();
//   List<Post>? listPosts; // all top posts (not including Top posts)
//   List<Like>? allLikes;
//   late User loggedUser;
//
//   void loadPostsByUser(BuildContext context) async {
//     setState(ViewState.Busy);
//     loggedUser = Provider.of<User>(context, listen: false);
//     allLikes = await _api!.getAllLikes();
//     List<Post>? listAllPosts = await _api!.getAllPost();
//     List<Comment>? listAllComments = await _api!.getListComment(null);
//     listPosts = <Post>[];
//
//     if (listAllPosts != null) {
//       for (Post post in listAllPosts) {
//         // Check LIKE for posts
//         if (allLikes != null) {
//           for (Like like in allLikes!) {
//             // Count every post's like
//             if (like.postId == post.postId) {
//               if (post.likeCount == null) post.likeCount = 0;
//               post.likeCount = post.likeCount! + 1;
//             }
//             // Check if logged user liked the post
//             if (post.isUserLiked == null) post.isUserLiked = false;
//             if (like.postId == post.postId && like.likedUserId == loggedUser.id) {
//               post.isUserLiked = true;
//             }
//           }
//         }
//
//         // Check COMMENT for posts
//         if (listAllComments != null) {
//           for (Comment comment in listAllComments) {
//             if (comment.postId == post.postId) {
//               List<Comment>? commentOfThisPost = post.listComment;
//               if (commentOfThisPost == null) commentOfThisPost = <Comment>[];
//               commentOfThisPost.add(comment);
//               post.listComment = commentOfThisPost;
//             }
//           }
//         }
//
//         // Seperate top posts and other posts
//         if (!post.isFeatured!) listPosts!.add(post);
//       }
//     }
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
// }
