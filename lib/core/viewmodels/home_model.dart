// import 'dart:async';
// import 'package:sillyhouseorg/core/classes/activity.dart';
// import 'package:sillyhouseorg/core/classes/user.dart';
// import 'package:sillyhouseorg/core/enums/view_state.dart';
// import 'package:sillyhouseorg/core/services/api.dart';
// import 'package:sillyhouseorg/core/services/authentication_service.dart';
// import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
// import 'package:sillyhouseorg/global/global.dart';
//
// class HomeModel extends BaseModel {
//   final Api? _api = Api();
//
//   List<Activity>? listFeaturedActivity;
//
//   void initHomeView() async {
//     setState(ViewState.Busy);
//     final AuthenticationService _authenticationService = AuthenticationService();
//     User user = await (_authenticationService.getUserFromCache() as FutureOr<User>);
//     getFeaturedActivity();
//     app.challengeSubmit = await _api!.getChallengeSubmitByUser(user);
//     setState(ViewState.Idle);
//   }
//
//   void getFeaturedActivity() async {
//     List<Activity> allActivity = await (_api!.getAllActivity() as FutureOr<List<Activity>>);
//     listFeaturedActivity = [];
//     for (Activity activity in allActivity) if (activity.isActive! && activity.isFeatured!) listFeaturedActivity!.add(activity);
//     notifyListeners();
//   }
// }
