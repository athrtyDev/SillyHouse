import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  ChallengeSubmit? challengeSubmit;
  List<ActivityType>? activityTypes;
  List<Activity>? listFeaturedActivity;

  HomeLoaded({this.listFeaturedActivity, this.challengeSubmit, this.activityTypes});

  HomeLoaded copyWith({
    ChallengeSubmit? challengeSubmit,
    List<ActivityType>? activityTypes,
    List<Activity>? listFeaturedActivity,
  }) {
    return HomeLoaded(
      listFeaturedActivity: listFeaturedActivity ?? this.listFeaturedActivity,
      challengeSubmit: challengeSubmit ?? this.challengeSubmit,
      activityTypes: activityTypes ?? this.activityTypes,
    );
  }

  @override
  List<Object?> get props => [challengeSubmit, activityTypes, listFeaturedActivity];
}
