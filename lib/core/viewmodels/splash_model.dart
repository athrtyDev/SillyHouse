import 'package:package_info/package_info.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:flutter/material.dart';

class SplashModel extends BaseModel {
  final Api? _api = locator<Api>();

  void initData(BuildContext context) async {
    final AuthenticationService _authenticationService = locator<AuthenticationService>();
    User? user = await _authenticationService.getUserFromCache();
    app.interfaceDynamic = await _api!.getInterfaceDynamic();
    app.activityTypes = await _api!.getActivityType();
    await checkUpdate(context);
    print('App config loaded!');
    Navigator.pushNamed(context, user != null ? '/mainPage' : '/greeting');
  }

  checkUpdate(BuildContext context) async {
    // Check app version to update
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      print('app verions: $version vs db app version: ${app.interfaceDynamic!.appVersion}');
      if (app.interfaceDynamic!.appVersion != version) Navigator.pushNamed(context, '/update');
    } catch (e) {
      print('error: Failed to check version');
    }
  }
}
