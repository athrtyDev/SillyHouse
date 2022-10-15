import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sillyhouseorg/bloc/post/post_cubit.dart';
import 'package:sillyhouseorg/core/classes/constant.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app/cubit.dart';
import 'bloc/user/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  app = Globals();
  final storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  MyApp();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final AppRouter _appRouter = AppRouter();
  final AppCubit appCubit = AppCubit();
  final UserCubit userCubit = UserCubit();
  final PostCubit postCubit = PostCubit();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(
            create: (context) => appCubit,
          ),
          BlocProvider<UserCubit>(
            create: (context) => userCubit,
          ),
          BlocProvider<PostCubit>(
            create: (context) => postCubit,
          ),
        ],
        child: MaterialApp(
          title: 'Silly House',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'NunitoSans',
          ),
          initialRoute: ('/splash'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _appRouter.generateRoute,
          navigatorKey: NavKey,
        ));
  }
}
