import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'cubit.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitState());

  void getAllActivity() async {
    emit(ActivityLoading());
    Map<String?, List<Activity>?> mapActivity = new Map<String?, List<Activity>?>();
    List<Activity>? allActivity = await app.getAllActivity();
    for (Activity activity in allActivity!) {
      if (!activity.isActive!) continue;
      List<Activity>? newList = [];
      if (mapActivity.containsKey(activity.activityType)) newList = mapActivity[activity.activityType];
      newList!.add(activity);
      mapActivity[activity.activityType] = newList;
    }
    emit(ActivityLoaded(mapActivity: mapActivity));
  }
}
