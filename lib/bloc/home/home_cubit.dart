import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitState());

  void initData(String userId) async {
    emit(HomeLoading());
    try {
      List<Post>? listAllPosts = await app.getAllPost(userId);
      List<Post> listFeatured = [];
      if (listAllPosts != null)
        for (var item in listAllPosts) if (item.isFeatured != null && item.isFeatured!) listFeatured.add(item);
      emit(HomeLoaded(listAllPost: listAllPosts, listFeaturedPost: listFeatured));
    } catch (e) {
      print("error home initData: ${e.toString()}");
      emit(HomeLoaded(listAllPost: null));
    }
  }

  void _initData(String userId) async {
    // TODO remove after design change
    try {
      // Submitted challenges
      if (app.challengeSubmit == null) {
        final Api _api = Api();
        app.challengeSubmit = await _api.getChallengeSubmitByUser(userId);
      }

      // Featured activities
      List<Activity>? listFeaturedActivity = [];
      List<Activity>? allActivity = await app.getAllActivity();
      if (allActivity != null && allActivity.isNotEmpty) {
        for (Activity activity in allActivity) {
          if (activity.isActive! && activity.isFeatured!) {
            listFeaturedActivity.add(activity);
          }
        }
      }
    } on Exception catch (e) {
      print("error home initData: ${e.toString()}");
    }
  }
}
