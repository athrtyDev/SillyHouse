// import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
// import 'package:sillyhouseorg/core/classes/post.dart';
// import 'package:sillyhouseorg/core/classes/user.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/services/api.dart';
// import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
// import 'package:sillyhouseorg/global/global.dart';
//
// class ChooseChallengeModel extends BaseModel {
//   final Api? _api = Api();
//   List<Post>? listAllUserPost;
//   List<Post> listSelectedPost = [];
//
//   void initData(List<Post>? listAllPost) async {
//     setState(ViewState.Busy);
//     listAllUserPost = listAllPost;
//     if (app.challengeSubmit!.listPost != null && app.challengeSubmit!.listPost!.isNotEmpty)
//       for (var submit in app.challengeSubmit!.listPost!) {
//         for (var item in listAllPost!) {
//           if (item.postId == submit.postId) {
//             item.isSelected = true;
//             listSelectedPost.add(item);
//           }
//         }
//       }
//
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
//
//   void selectPost(Post post) async {
//     setState(ViewState.Busy);
//     post.isSelected = !post.isSelected;
//     if (post.isSelected)
//       listSelectedPost.add(post);
//     else if (listSelectedPost.contains(post)) listSelectedPost.remove(post);
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
//
//   submitChallenge(User user) async {
//     setState(ViewState.Busy);
//     ChallengeSubmit submit = app.challengeSubmit!;
//     submit.userId = user.id;
//     submit.userName = user.name;
//     submit.listPost = listSelectedPost;
//     submit.done = listSelectedPost.length;
//     submit.modifiedDate = DateTime.now().toString();
//     if (submit.docId == null)
//       await _api!.createChallengeSubmit(submit);
//     else
//       await _api!.updateChallengeSubmit(submit);
//     app.challengeSubmit = submit;
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
// }
