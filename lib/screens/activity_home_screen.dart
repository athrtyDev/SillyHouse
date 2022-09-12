import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/bloc/activity/cubit.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/difficulty_progress.dart';
import 'package:sillyhouseorg/widgets/home_header.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ActivityHomeScreen extends StatefulWidget {
  ActivityHomeScreen();

  @override
  _ActivityHomeScreenState createState() => _ActivityHomeScreenState();
}

class _ActivityHomeScreenState extends State<ActivityHomeScreen> {
  ActivityCubit cubit = ActivityCubit();

  @override
  void initState() {
    super.initState();
    cubit.getAllActivity();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
          return new Future.value(true);
        },
        child: Container(
          color: Styles.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<ActivityCubit, ActivityState>(
                    bloc: cubit,
                    builder: (context, state) {
                      if (state is ActivityLoaded) {
                        return Column(
                          children: [
                            for (var item in state.listActivityType)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: _activityGroupTile(item, state.mapActivity[item.type]),
                              ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _activityGroupTile(ActivityType type, List<Activity>? listActivity) {
    return (listActivity == null || listActivity.isEmpty)
        ? SizedBox()
        : Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Styles.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/activity_list_route', arguments: listActivity);
                  },
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText.large(
                            type.name!,
                            // textColor: Utils.getActivityTypeColor(type.type!),
                          ),
                          MyText.small(
                            "${listActivity.length} хичээл",
                            // textColor: Utils.getActivityTypeColor(type.type!),
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Utils.getActivityTypeColor(type.type!).withOpacity(0.2),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            MyText.small(
                              "Бүгд ",
                              textColor: Utils.getActivityTypeColor(type.type!),
                            ),
                            SvgPicture.asset('lib/assets/arrow.svg',
                                color: Utils.getActivityTypeColor(type.type!).withOpacity(0.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 170,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var item in listActivity)
                            InkWell(
                              onTap: () {
                                baseFunctions.logCatcher(eventName: "Activity_List_${item.name}");
                                Navigator.pushNamed(context, '/activity_instruction', arguments: item);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 7),
                                child: _activityWidget(item),
                              ),
                            ),
                        ],
                      )),
                )
              ],
            ),
          );
  }

  Widget _activityWidget(Activity activity) {
    double width = 140;
    return Column(
      children: [
        Container(
          height: 140,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: activity.coverImageUrl!,
              errorWidget: (context, url, error) => Icon(Icons.person_outline_rounded, size: 18),
            ),
          ),
        ),
        Container(
          width: width,
          height: 30,
          // color: Colors.green,
          padding: EdgeInsets.only(top: 5, right: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: MyText.medium(cutString(activity.name!))),
                ],
              ),
              SizedBox(height: 5),
              DifficultyProgress(level: activity.difficulty!),
            ],
          ),
        ),
      ],
    );
  }

  String cutString(String text) {
    int maxLength = 16;
    if (text.length < maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }
}
