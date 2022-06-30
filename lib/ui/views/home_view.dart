import 'package:cached_network_image/cached_network_image.dart';
import 'package:sillyhouseorg/core/classes/Interface_dynamic.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/widgets/activity_tile.dart';
import 'package:sillyhouseorg/ui/widgets/challenge_type.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:sillyhouseorg/core/viewmodels/home_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/ui/widgets/profile_picture.dart';
import 'package:sillyhouseorg/ui/widgets/weekly_progress_bar.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController? scrollViewController;
  late ScrollController postViewController;
  late ScrollController scrollBestPostController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    postViewController = ScrollController();
    scrollBestPostController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController!.dispose();
    postViewController.dispose();
    scrollBestPostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.initHomeView(),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.white,
                child: Column(
                  children: [
                    _greeting(),
                    Expanded(
                      child: ListView(children: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 20),
                            _weeklyChallenge(app.interfaceDynamic!),
                            SizedBox(height: 20),
                            //TopPostPanel(),
                            _activityTypes(app.activityTypes!),
                            SizedBox(height: 20),
                            _challenges(model),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _greeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: ProfilePicture(
                url: Provider.of<User>(context, listen: true).profile_pic,
                onTap: () {
                  String? userType = Provider.of<User>(context, listen: false).type;
                  print('user type: ' + userType.toString());
                  if (userType != null && userType == "admin") Navigator.pushNamed(context, '/admin');
                },
              ),
            ),
            SizedBox(width: 8),
            Text('Сайн уу, ${Provider.of<User>(context, listen: true).name}!',
                style: GoogleFonts.kurale(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                )),
            //Image.asset('lib/ui/images/icon_wave_hand.png', height: 20)
          ],
        ),
        // NOTIFICATION
        // GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(context, '/notification');
        //     },
        //     child: Stack(
        //       children: [
        //         Container(
        //           padding: EdgeInsets.all(10),
        //           decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        //           child: Icon(Icons.notifications, size: 21, color: AppColors.secondaryTextColor),
        //         ),
        //         Positioned(
        //           right: 3,
        //           top: 3,
        //           child: Container(
        //             width: 15,
        //             height: 15,
        //             decoration: new BoxDecoration(
        //               color: Color(0xffc83d36),
        //               shape: BoxShape.circle,
        //             ),
        //             child: Center(
        //               child: Text('0', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
        //             ),
        //           ),
        //         ),
        //       ],
        //     )),
      ],
    );
  }

  _weeklyChallenge(InterfaceDynamic dynamic) {
    double _width = MediaQuery.of(context).size.width - 50;
    return InkWell(
      onTap: () async {
        Navigator.pushNamed(context, '/challenge_home');
      },
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: dynamic.homePosterUrl == null
                  ? Image.asset("lib/ui/images/home_header2.png")
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: dynamic.homePosterUrl!,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
            if (app.challengeSubmit != null)
              Positioned(
                bottom: 10,
                child: Container(
                  width: _width,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Илгээсэн даалгавар',
                              style: GoogleFonts.kurale(
                                fontSize: 13,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              )),
                          Text("${app.challengeSubmit!.done}/${app.challengeSubmit!.total}",
                              style: GoogleFonts.kurale(
                                fontSize: 13,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              )),
                        ],
                      ),
                      SizedBox(height: 5),
                      WeeklyProgressBar(total: app.challengeSubmit!.total, done: app.challengeSubmit!.done, width: _width),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _activityTypes(List<ActivityType> listType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Сонгоод, туршаад үзээрэй',
                style: GoogleFonts.kurale(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                )),
            Icon(Icons.chevron_right),
          ],
        ),
        SizedBox(height: 15),
        GridView.count(
            controller: scrollViewController,
            crossAxisCount: 4,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: listType.map((ActivityType type) {
              return ChallengeType(
                onTap: () {
                  Navigator.pushNamed(context, '/activity_list', arguments: {
                    'listType': listType,
                    'selectedType': type,
                  });
                },
                image: CachedNetworkImage(
                  imageUrl: type.image!,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                name: type.name,
              );
            }).toList()),
      ],
    );
  }

  _challenges(HomeModel model) {
    if (model.listFeaturedActivity == null)
      return SizedBox();
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Шилдэг даалгаврууд',
              style: GoogleFonts.kurale(
                fontSize: 18,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              )),
          SizedBox(height: 10),
          GridView.count(
            controller: scrollViewController,
            crossAxisCount: 2,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            children: model.listFeaturedActivity!.map((Activity activity) {
              return ActivityTile(
                activity: activity,
                color: AppColors.backgroundColor,
                onTap: () {
                  Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                },
              );
            }).toList(),
          ),
        ],
      );
  }
}
