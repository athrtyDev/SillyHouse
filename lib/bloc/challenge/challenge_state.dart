import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/weekly_challenge.dart';

abstract class ChallengeState {}

class ChallengeInitState extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  List<WeeklyChallenge> listChallenge;
  List<Post>? listUserPosts;

  ChallengeLoaded({required this.listChallenge, required this.listUserPosts});

  @override
  List<Object?> get props => [listChallenge, listUserPosts];
}

class ChooseChallengeLoaded extends ChallengeState {
  List<Post> listSelectedPost;
  bool isLoading;

  ChooseChallengeLoaded({required this.listSelectedPost, this.isLoading = false});

  @override
  List<Object?> get props => [listSelectedPost, isLoading];
}
