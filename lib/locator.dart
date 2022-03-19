import 'package:sillyhouseorg/core/viewmodels/activity_home_model.dart';
import 'package:sillyhouseorg/core/viewmodels/activity_instruction_model.dart';
import 'package:sillyhouseorg/core/viewmodels/admin_model.dart';
import 'package:sillyhouseorg/core/viewmodels/challenge_home_model.dart';
import 'package:sillyhouseorg/core/viewmodels/choose_challenge_model.dart';
import 'package:sillyhouseorg/core/viewmodels/gallery_model.dart';
import 'package:sillyhouseorg/core/viewmodels/main_page_model.dart';
import 'package:sillyhouseorg/core/viewmodels/post_stories_model.dart';
import 'package:sillyhouseorg/core/viewmodels/profile_model.dart';
import 'package:sillyhouseorg/core/viewmodels/publish_model.dart';
import 'package:get_it/get_it.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/core/viewmodels/home_model.dart';
import 'package:sillyhouseorg/core/viewmodels/login_model.dart';
import 'package:sillyhouseorg/core/viewmodels/splash_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => SplashModel());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => MainPageModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => ActivityHomeModel());
  locator.registerFactory(() => ActivityInstructionModel());
  locator.registerFactory(() => AdminModel());
  locator.registerFactory(() => PublishModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => GalleryModel());
  locator.registerFactory(() => PostStoriesModel());
  locator.registerFactory(() => ChallengeHomeModel());
  locator.registerFactory(() => ChooseChallengeModel());
}
