import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<Post>? listAllPost;
  List<Post>? listFeaturedPost;

  HomeLoaded({this.listAllPost, this.listFeaturedPost});

  @override
  List<Object?> get props => [listAllPost, listFeaturedPost];
}
