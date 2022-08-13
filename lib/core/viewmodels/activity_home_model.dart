// import 'package:sillyhouseorg/core/classes/activity.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/services/api.dart';
// import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
// import 'package:sillyhouseorg/global/global.dart';
//
// class ActivityHomeModel extends BaseModel {
//   final Api? _api = Api();
//   late Map<String?, List<Activity>?> mapActivity;
//
//   void getActivityList(String? activityType) async {
//     setState(ViewState.Busy);
//     if (app.listAllActivity == null) app.listAllActivity = await _api!.getAllActivity();
//     mapActivity = new Map<String?, List<Activity>?>();
//     for (Activity activity in app.listAllActivity!) {
//       if (!activity.isActive!) continue;
//       List<Activity>? newList = [];
//       if (mapActivity.containsKey(activity.activityType)) newList = mapActivity[activity.activityType];
//       newList!.add(activity);
//       mapActivity[activity.activityType] = newList;
//     }
//
//     setState(ViewState.Idle);
//     notifyListeners();
//   }
// }
