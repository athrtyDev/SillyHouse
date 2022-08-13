import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/classes/weekly_challenge.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'cubit.dart';

class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit() : super(ChallengeInitState());

  void initChallenge(String userId) async {
    emit(ChallengeLoading());
    List<WeeklyChallenge> listChallenge = [];
    listChallenge.add(new WeeklyChallenge(
      title: "Өөрийн 3-н бүтээлээ илгээнэ.",
      type: "sendChallenge",
      icon: Icon(Icons.check, size: 15, color: Colors.white),
    ));
    listChallenge.add(new WeeklyChallenge(
      title: "Ялагч 1 дэх өдөр тодроно.",
      icon: Icon(Icons.wine_bar, size: 15, color: Colors.white),
    ));
    final Api? _api = Api();
    List<Post>? listUserPosts = await _api!.getPostByUser(userId);
    emit(ChallengeLoaded(listChallenge: listChallenge, listUserPosts: listUserPosts));
  }

  void initChooseChallenge(List<Post>? listAllPost) async {
    List<Post> listSelectedPost = [];
    if (app.challengeSubmit!.listPost != null && app.challengeSubmit!.listPost!.isNotEmpty)
      for (var submit in app.challengeSubmit!.listPost!) {
        for (var item in listAllPost!) {
          if (item.postId == submit.postId) {
            item.isSelected = true;
            listSelectedPost.add(item);
          }
        }
      }
    emit(ChooseChallengeLoaded(listSelectedPost: listSelectedPost));
  }

  void selectPost(Post post) async {
    List<Post> listSelectedPost = (state as ChooseChallengeLoaded).listSelectedPost;
    post.isSelected = !post.isSelected;
    if (post.isSelected)
      listSelectedPost.add(post);
    else if (listSelectedPost.contains(post)) listSelectedPost.remove(post);
    emit(ChooseChallengeLoaded(listSelectedPost: listSelectedPost));
  }

  submitChallenge(User user) async {
    List<Post> listSelectedPost = (state as ChooseChallengeLoaded).listSelectedPost;
    emit(ChooseChallengeLoaded(listSelectedPost: listSelectedPost, isLoading: true));
    ChallengeSubmit submit = app.challengeSubmit!;
    submit.userId = user.id;
    submit.userName = user.name;
    submit.listPost = listSelectedPost;
    submit.done = listSelectedPost.length;
    submit.modifiedDate = DateTime.now().toString();
    final Api? _api = Api();
    if (submit.docId == null)
      await _api!.createChallengeSubmit(submit);
    else
      await _api!.updateChallengeSubmit(submit);
    app.challengeSubmit = submit;
    emit(ChooseChallengeLoaded(listSelectedPost: listSelectedPost, isLoading: false));
  }
}
