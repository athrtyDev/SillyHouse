import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/challenge_point.dart';
import 'package:sillyhouseorg/widgets/difficulty_level.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/rectangle_post.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ActivityListScreen extends StatefulWidget {
  final List<Activity> listActivity;

  const ActivityListScreen({Key? key, required this.listActivity}) : super(key: key);

  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: Utils.getActivityTypeName(widget.listActivity[0].activityType).name,
        textColor: Utils.getActivityTypeColor(widget.listActivity[0].activityType!),
      ),
      backgroundColor: Styles.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              for (var item in widget.listActivity)
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: _activityWidget(item),
                ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityWidget(Activity activity) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width - 20,
          width: MediaQuery.of(context).size.width - 20,
          child: InkWell(
            onTap: () {
              baseFunctions.logCatcher(eventName: "Activity_List_${activity.name}");
              Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Hero(
                tag: "activity${activity.id}",
                child: RectanglePost(
                  imageUrl: activity.coverImageUrl!,
                  header: activity.name!,
                  subHeader: "2022.07.19", // TODO
                  // description: Utils.getActivityTypeName(activity.activityType!).name!,
                  // descColor: Utils.getActivityTypeColor(activity.activityType!),
                  bottomWidget: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment(1, 0),
                    child: ChallengePoint(point: activity.skill!),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Styles.whiteColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          ),
          child: DifficultyLevel(level: activity.difficulty!),
        ),
      ],
    );
  }
}
