import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sillyhouseorg/screens/activity_home_screen.dart';
import 'package:sillyhouseorg/screens/coming_soon_screen.dart';
import 'package:sillyhouseorg/screens/home_screen.dart';
import 'package:sillyhouseorg/screens/profile_screen.dart';
import 'package:sillyhouseorg/screens/test.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class MainPageScreen extends StatefulWidget {
  final dynamic args;
  MainPageScreen({this.args});

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  bool? uploadSuccess;
  int tabIndex = 0;
  PageController? _pageController;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      uploadSuccess = widget.args['uploadSuccess'];
      if (widget.args['tabIndex'] != null) tabIndex = widget.args['tabIndex'];
    }
    _pageController = PageController(initialPage: tabIndex);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showUploadStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Styles.whiteColor,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            body: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => tabIndex = index);
              },
              children: <Widget>[
                HomeScreen(),
                ActivityHomeScreen(),
                // CameraScreen(),
                ComingSoonScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: bottomNavBar(),
          ),
        ),
      ),
    );
  }

  bottomNavBar() {
    return Container(
      color: Styles.whiteColor,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          tabItem("Нүүр", "home", Styles.baseColor1, 0),
          tabItem("Хичээл", "activity", Styles.baseColor2, 1),
          // tabItem("Камер", "camera", Styles.baseColor3, 2),
          tabItem("Тэмцээн", "contest", Styles.baseColor4, 2),
          tabItem("Миний", "profile", Styles.baseColor5, 3),
          SizedBox(),
        ],
      ),
    );
  }

  Widget tabItem(String name, String icon, Color color, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          tabIndex = index;
          _pageController!.jumpToPage(index);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'lib/assets/tab_$icon.svg',
            height: 22,
            color: tabIndex == index ? color : color.withOpacity(0.3),
          ),
          SizedBox(height: 2),
          MyText.medium(
            name,
            textColor: tabIndex == index ? color : Styles.textColor70,
          )
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    if (tabIndex != 0) {
      setState(() => tabIndex = 0);
      _pageController!.jumpToPage(0);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime != null && now.difference(currentBackPressTime!) < Duration(seconds: 1)) {
        currentBackPressTime = now;
        SystemNavigator.pop();
      }
      currentBackPressTime = now;
    }
    return Future.value(false);
  }

  _showUploadStatus() {
    if (uploadSuccess != null && uploadSuccess!) {
      Flushbar(
        message: 'Бүтээл амжилттай хуулагдлаа.',
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
