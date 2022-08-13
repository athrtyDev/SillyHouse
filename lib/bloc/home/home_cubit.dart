import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitState());

  void initData(String userId) async {
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

      emit(HomeLoaded(
        challengeSubmit: app.challengeSubmit,
        activityTypes: await app.getActivityType(),
        listFeaturedActivity: listFeaturedActivity,
      ));
    } on Exception catch (e) {
      print("error home initData: ${e.toString()}");
    }
  }
}
