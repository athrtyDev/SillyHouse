import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/ui/views/activity_home_view.dart';
import 'package:sillyhouseorg/ui/views/activity_instruction_view.dart';
import 'package:sillyhouseorg/ui/views/admin_view.dart';
import 'package:sillyhouseorg/ui/views/challenge_home_view.dart';
import 'package:sillyhouseorg/ui/views/choose_challenge_post_view.dart';
import 'package:sillyhouseorg/ui/views/gallery_view.dart';
import 'package:sillyhouseorg/ui/views/login/login_view.dart';
import 'package:sillyhouseorg/ui/views/notification_view.dart';
import 'package:sillyhouseorg/ui/views/post_detail_view.dart';
import 'package:sillyhouseorg/ui/views/profile_view.dart';
import 'package:sillyhouseorg/ui/views/publish_view.dart';
import 'package:sillyhouseorg/ui/views/login/register_view.dart';
import 'package:sillyhouseorg/ui/views/login/splash_view.dart';
import 'package:sillyhouseorg/ui/views/update_view.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/ui/views/mainPage_view.dart';
import 'package:sillyhouseorg/ui/views/login/greeting_view.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/greeting':
        return MaterialPageRoute(builder: (_) => GreetingView());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case '/mainPage':
        var uploadSuccess = settings.arguments as bool?;
        return MaterialPageRoute(builder: (_) => MainPageView(uploadSuccess: uploadSuccess));
      case '/activity_list':
        dynamic args = settings.arguments;
        List<ActivityType>? listType = args['listType'];
        ActivityType? selectedType = args['selectedType'];
        return MaterialPageRoute(builder: (_) => ActivityHomeView(listType: listType, selectedType: selectedType));
      case '/activity_instruction':
        var activity = settings.arguments as Activity?;
        return MaterialPageRoute(builder: (_) => ActivityInstructionView(activity: activity));
      case '/post_detail':
        var post = settings.arguments as Post?;
        return MaterialPageRoute(builder: (_) => PostDetailView(post: post));
      case '/publish':
        var post = settings.arguments as Post?;
        return MaterialPageRoute(builder: (_) => PublishView(post: post));
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileView());
      case '/gallery':
        return MaterialPageRoute(builder: (_) => GalleryView());
      case '/notification':
        return MaterialPageRoute(builder: (_) => NotificationView());
      case '/update':
        return MaterialPageRoute(builder: (_) => UpdateView());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminView());
      case '/challenge_home':
        return MaterialPageRoute(builder: (_) => ChallengeHomeView());
      case '/choose_challenge_post':
        List<Post>? listUserPost = settings.arguments as List<Post>?;
        return MaterialPageRoute(builder: (_) => ChooseChallengePostView(listUserPost: listUserPost));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
