import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'cubit.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitState());

  checkUpdate() async {
    try {
      final Api _api = Api();
      app.interfaceDynamic = await _api.getInterfaceDynamic(); // get DB version number
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      print('App verions: $version vs DB version: ${app.interfaceDynamic!.appVersion}');
      if (app.interfaceDynamic!.appVersion == version) {
        await app.getActivityType();
        emit(LatestVersion());
      } else {
        emit(OldVersion());
      }
    } catch (e) {
      print('error: Failed to check version');
    }
  }
}
