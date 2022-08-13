import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/screens/activity_home_screen.dart';
import 'package:sillyhouseorg/screens/activity_instruction_screen.dart';
import 'package:sillyhouseorg/screens/admin_screen.dart';
import 'package:sillyhouseorg/screens/challenge_home_screen.dart';
import 'package:sillyhouseorg/screens/choose_challenge_post_screen.dart';
import 'package:sillyhouseorg/screens/login/login_screen.dart';
import 'package:sillyhouseorg/screens/post_detail_screen.dart';
import 'package:sillyhouseorg/screens/publish_screen.dart';
import 'package:sillyhouseorg/screens/login/register_screen.dart';
import 'package:sillyhouseorg/screens/login/splash_screen.dart';
import 'package:sillyhouseorg/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/screens/mainPage_screen.dart';
import 'package:sillyhouseorg/screens/login/greeting_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {

      /// LOGIN
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/update':
        return MaterialPageRoute(builder: (_) => UpdateScreen());
      case '/greeting':
        return MaterialPageRoute(builder: (_) => GreetingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      /// MAIN SCREENS
      case '/mainPage':
        var uploadSuccess = settings.arguments as bool?;
        return MaterialPageRoute(builder: (_) => MainPageScreen(uploadSuccess: uploadSuccess));
      case '/activity_list':
        dynamic args = settings.arguments;
        List<ActivityType>? listType = args['listType'];
        ActivityType? selectedType = args['selectedType'];
        return MaterialPageRoute(builder: (_) => ActivityHomeScreen(listType: listType!, selectedType: selectedType));
      case '/activity_instruction':
        var activity = settings.arguments as Activity?;
        return MaterialPageRoute(builder: (_) => ActivityInstructionScreen(activity: activity));
      case '/post_detail':
        var post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => PostDetailScreen(post: post));
      case '/publish':
        var post = settings.arguments as Post?;
        return MaterialPageRoute(builder: (_) => PublishScreen(post: post));
      // case '/profile':
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      // case '/gallery':
      //   return MaterialPageRoute(builder: (_) => GalleryScreen());
      // case '/notification':
      //   return MaterialPageRoute(builder: (_) => NotificationScreen());

      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminScreen());
      case '/challenge_home':
        return MaterialPageRoute(builder: (_) => ChallengeHomeScreen());
      case '/choose_challenge_post':
        List<Post>? listUserPost = settings.arguments as List<Post>?;
        return MaterialPageRoute(builder: (_) => ChooseChallengePostScreen(listUserPost: listUserPost));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
