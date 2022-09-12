import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/home/cubit.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/core/classes/challenge_submit.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/widgets/activity_tile.dart';
import 'package:sillyhouseorg/widgets/challenge_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/weekly_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeCubit cubit = HomeCubit();
  late ScrollController activityTypeController;
  late ScrollController topChallengeController;
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state.user!;
    cubit.initData(user.id!);
    activityTypeController = ScrollController();
    topChallengeController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: Colors.white,
        child: Column(
          children: [
            _greeting(),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: cubit,
                  builder: (context, state) {
                    if (state is HomeLoaded) {
                      return ListView(children: <Widget>[
                        Column(
                          children: [
                            // _weeklyChallenge(state.challengeSubmit),
                            // SizedBox(height: 30),
                            // _activityTypes(state.activityTypes),
                            // SizedBox(height: 40),
                            // topActivity(state.listFeaturedActivity),
                          ],
                        ),
                      ]);
                    } else
                      return SizedBox();
                  }),
            ),
          ],
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
                url: user.profile_pic,
                onTap: () {
                  String? userType = user.type;
                  print('user type: ' + userType.toString());
                  if (userType != null && userType == "admin") Navigator.pushNamed(context, '/admin');
                },
              ),
            ),
            SizedBox(width: 8),
            Text('Сайн уу, ${user.name}!',
                style: GoogleFonts.kurale(
                  fontSize: 16,
                  color: Styles.textColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                )),
            //Image.asset('lib/assets/icon_wave_hand.png', height: 20)
          ],
        ),
      ],
    );
  }

  _weeklyChallenge(ChallengeSubmit? challengeSubmit) {
    double _width = MediaQuery.of(context).size.width - 50;
    return challengeSubmit == null
        ? SizedBox()
        : InkWell(
            onTap: () {
              baseFunctions.logCatcher(eventName: "Home_Challenge");
              Navigator.pushNamed(context, '/challenge_home');
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: app.interfaceDynamic!.homePosterUrl == null
                        ? Image.asset("lib/assets/home_header2.png")
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: app.interfaceDynamic!.homePosterUrl!,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: _width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(challengeSubmit.done == 0 ? 'Тэмцээнд орох' : 'Илгээсэн даалгавар',
                                  style: GoogleFonts.kurale(
                                    fontSize: 13,
                                    color: Styles.textColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  )),
                              Text("${challengeSubmit.done}/${challengeSubmit.total}",
                                  style: GoogleFonts.kurale(
                                    fontSize: 13,
                                    color: Styles.textColor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  )),
                            ],
                          ),
                          SizedBox(height: 5),
                          WeeklyProgressBar(total: challengeSubmit.total, done: challengeSubmit.done, width: _width),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _activityTypes(List<ActivityType>? activityTypes) {
    return (activityTypes == null || activityTypes.isEmpty)
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Сонгоод, туршаад үзээрэй',
                      style: GoogleFonts.kurale(
                        fontSize: 16,
                        color: Styles.textColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      )),
                  Icon(Icons.chevron_right),
                ],
              ),
              SizedBox(height: 15),
              GridView.count(
                  controller: activityTypeController,
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: activityTypes.map((ActivityType type) {
                    return ChallengeType(
                      onTap: () {
                        baseFunctions.logCatcher(
                          eventName: "Home_ActivityType",
                          properties: {'type': type.name},
                        );
                        Navigator.pushNamed(context, '/activity_list', arguments: {
                          'listType': activityTypes,
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

  topActivity(List<Activity>? listFeaturedActivity) {
    return (listFeaturedActivity == null || listFeaturedActivity.isEmpty)
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Шилдэг даалгаврууд',
                  style: GoogleFonts.kurale(
                    fontSize: 16,
                    color: Styles.textColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  )),
              SizedBox(height: 10),
              GridView.count(
                controller: topChallengeController,
                crossAxisCount: 2,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: listFeaturedActivity.map((Activity activity) {
                  return ActivityTile(
                    activity: activity,
                    color: Styles.backgroundColor,
                    onTap: () {
                      baseFunctions.logCatcher(eventName: "Home_FeaturedActivity", properties: {'name': activity.name});
                      Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                    },
                  );
                }).toList(),
              ),
            ],
          );
  }
}
