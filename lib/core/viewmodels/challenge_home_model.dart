// import 'package:flutter/material.dart';
// import 'package:sillyhouseorg/core/classes/post.dart';
// import 'package:sillyhouseorg/core/classes/user.dart';
// import 'package:sillyhouseorg/core/classes/weekly_challenge.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/services/api.dart';
// import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
//
// class ChallengeHomeModel extends BaseModel {
//   final Api? _api = Api();
//   late List<WeeklyChallenge> listChallenge;
//   List<Post>? listUserPosts;
//
//   void initData(User loggedUser) async {
//     setState(ViewState.Busy);
//     listChallenge = [];
//     listChallenge.add(new WeeklyChallenge(
//       title: "Өөрийн 3-н бүтээлээ илгээнэ.",
//       type: "sendChallenge",
//       icon: Icon(Icons.check, size: 15, color: Colors.white),
//     ));
//     listChallenge.add(new WeeklyChallenge(
//       title: "Ялагч 1 дэх өдөр тодроно.",
//       icon: Icon(Icons.wine_bar, size: 15, color: Colors.white),
//     ));
//     listUserPosts = await _api!.getPostByUser(loggedUser);
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
// }
