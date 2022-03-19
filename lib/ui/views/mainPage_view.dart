import 'package:another_flushbar/flushbar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/scheduler.dart';
import 'package:sillyhouseorg/core/viewmodels/main_page_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/gallery_view.dart';
import 'package:sillyhouseorg/ui/views/home_view.dart';
import 'package:sillyhouseorg/ui/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPageView extends StatefulWidget {
  final bool uploadSuccess;
  MainPageView({bool this.uploadSuccess});

  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showUploadStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  PageController _pageController;
  DateTime currentBackPressTime;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView<MainPageModel>(
        builder: (context, model, child) => WillPopScope(
              onWillPop: onWillPop,
              child: Container(
                color: AppColors.whiteColor,
                child: SafeArea(
                  top: false,
                  child: ClipRect(
                    child: Scaffold(
                      extendBody: true,
                      body: Container(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() => _currentIndex = index);
                          },
                          children: <Widget>[
                            HomeView(),
                            GalleryView(),
                            ProfileView(),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomNavyBar(
                        selectedIndex: _currentIndex,
                        animationDuration: Duration(milliseconds: 350),
                        curve: Curves.easeInOutCirc,
                        onItemSelected: (index) {
                          setState(() => _currentIndex = index);
                          _pageController.jumpToPage(index);
                        },
                        items: <BottomNavyBarItem>[
                          BottomNavyBarItem(
                            icon: Icon(Icons.home),
                            title: Text('Нүүр', style: GoogleFonts.kurale()),
                            activeColor: AppColors.baseColor,
                            inactiveColor: AppColors.secondaryTextColor,
                          ),
                          BottomNavyBarItem(
                            icon: Icon(Icons.photo_library),
                            title: Text('Бүтээлүүд', style: GoogleFonts.kurale()),
                            activeColor: AppColors.baseColor,
                            inactiveColor: AppColors.secondaryTextColor,
                          ),
                          BottomNavyBarItem(
                            icon: Icon(Icons.person),
                            title: Text('Миний', style: GoogleFonts.kurale()),
                            activeColor: AppColors.baseColor,
                            inactiveColor: AppColors.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  Future<bool> onWillPop() {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.jumpToPage(0);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime != null && now.difference(currentBackPressTime) < Duration(seconds: 1)) {
        currentBackPressTime = now;
        SystemNavigator.pop();
      }
      currentBackPressTime = now;
    }
    return Future.value(false);
  }

  _showUploadStatus() {
    if (widget.uploadSuccess != null && widget.uploadSuccess) {
      Flushbar(
        message: 'Бүтээл амжилттай хуулагдлаа.',
        padding: EdgeInsets.all(25),
        backgroundColor: Color(0xff36c1c8),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
