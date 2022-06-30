import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:sillyhouseorg/ui/router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  app = Globals();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>(
        create: (_) => locator<AuthenticationService>().userController.stream,
        initialData: User.initial(),
        child: MaterialApp(
          title: 'Education',
          theme: ThemeData(),
          initialRoute: ('/splash'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: _appRouter.generateRoute,
        ));
  }
}
