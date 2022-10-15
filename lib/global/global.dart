import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/core/classes/Interface_dynamic.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/services/api.dart';

late Globals app;
SharedPreferences? storage;

class Globals {
  static Globals? _instance;

  factory Globals() {
    _instance ??= Globals._internal();
    return _instance!;
  }

  Globals._internal() {
    _init();
  }

  InterfaceDynamic? interfaceDynamic;
  List<ActivityType>? activityTypes;
  List<Activity>? allActivity;
  ChallengeSubmit? challengeSubmit;
  List<Post>? allPost;

  void _init() async {
    try {} catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
    }
  }

  Future<List<Activity>?> getAllActivity() async {
    if (allActivity == null) {
      final Api _api = Api();
      allActivity = await _api.getAllActivity();
    }
    return allActivity;
  }

  Future<List<ActivityType>?> getActivityType() async {
    if (activityTypes == null) {
      final Api _api = Api();
      activityTypes = await _api.getActivityType();
    }
    return activityTypes;
  }

  // Future<List<Post>?> getAllPost(String userId) async {
  //   if (allPost == null) {
  //     final Api _api = Api();
  //     allPost = await _api.getAllPost();
  //     if (allPost != null) {
  //       for (var item in allPost!) {
  //         item.isUserLiked = item.likedUserIds.contains(userId);
  //       }
  //     }
  //   }
  //   return allPost;
  // }
  //
  // Future<List<Post>?> getListNormalPost(String userId) async {
  //   List<Post>? all = await getAllPost(userId);
  //   List<Post> listNormal = [];
  //   if (all != null) for (var item in all) if (item.isFeatured == null || !item.isFeatured!) listNormal.add(item);
  //   return listNormal;
  // }
  //
  // Future<List<Post>?> getListFeaturedPost(String userId) async {
  //   List<Post>? all = await getAllPost(userId);
  //   List<Post> listFeatured = [];
  //   if (all != null) for (var item in all) if (item.isFeatured != null && item.isFeatured!) listFeatured.add(item);
  //   return listFeatured;
  // }
}
