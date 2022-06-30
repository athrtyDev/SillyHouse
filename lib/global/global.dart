import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/core/classes/Interface_dynamic.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/locator.dart';

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

  List<ActivityType>? activityTypes;
  InterfaceDynamic? interfaceDynamic;
  List<Activity>? listAllActivity;
  ChallengeSubmit? challengeSubmit;

  void _init() async {
    try {} catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
    }
  }

  void logOut() {
    challengeSubmit = null;
    final AuthenticationService _authenticationService = locator<AuthenticationService>();
    _authenticationService.removeUserFromStreamAndCache();
  }
}
