import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/challenge/cubit.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/weekly_challenge.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/widgets/my_media_player.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/weekly_progress_bar.dart';

class ChallengeHomeScreen extends StatefulWidget {
  @override
  _ChallengeHomeScreenState createState() => _ChallengeHomeScreenState();
}

class _ChallengeHomeScreenState extends State<ChallengeHomeScreen> {
  ChallengeCubit cubit = ChallengeCubit();
  List<Post>? relatedPosts;
  late ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    cubit.initChallenge(context.read<UserCubit>().state.user!.id!);
  }

  @override
  void dispose() {
    scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.whiteColor,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios_rounded, color: Styles.textColor),
          ),
          title: Text("Шагналт тэмцээн",
              style: GoogleFonts.kurale(
                fontSize: 18,
                color: Styles.textColor,
                fontWeight: FontWeight.w500,
              )),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<ChallengeCubit, ChallengeState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is ChallengeLoaded) {
              return Column(children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: MyMediaPlayer(
                    url:
                        "https://firebasestorage.googleapis.com/v0/b/education-69b9a.appspot.com/o/activity_diy%2Frainbow%20tissue%2Frainbow.mov?alt=media&token=67373a92-b771-42f5-b921-f2dc599d533b",
                    type: "video",
                  ),
                ),
                _infoHeader(),
                Padding(
                  padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                  child: _stepperInstruction(state.listChallenge, state.listUserPosts),
                ),
                Expanded(child: SizedBox()),
                state.listUserPosts == null ? _noPostWarning() : SizedBox(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(bottom: 30),
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: state.listUserPosts == null ? Colors.blueGrey.shade100 : Styles.baseColor1,
                      elevation: 4.0,
                    ),
                    child: Text('Тэмцээнд оролцох', style: GoogleFonts.kurale(fontSize: 16)),
                    onPressed: () {
                      if (state.listUserPosts == null)
                        Flushbar(
                          message: 'Бүтээл хийгээгүй байна.',
                          padding: EdgeInsets.all(25),
                          backgroundColor: Styles.baseColor1,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      else {
                        baseFunctions.logCatcher(eventName: "Challenge_Enter");
                        Navigator.popAndPushNamed(context, '/choose_challenge_post', arguments: state.listUserPosts);
                      }
                    },
                  ),
                ),
              ]);
            } else
              return SizedBox();
          },
        ),
      ),
    );
  }

  _infoHeader() {
    return Column(
      children: [
        // INSTRUCTION
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    Icon(Icons.rocket_launch, size: 20, color: Styles.textColor.withOpacity(0.5)),
                    SizedBox(width: 5),
                    Text("Дээрх шагналыг хожоорой.",
                        style: GoogleFonts.kurale(
                          color: Styles.textColor70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  _stepperInstruction(List<WeeklyChallenge> listChallenge, List<Post>? listUserPosts) {
    return Column(
      children: [
        for (int index = 0; index < listChallenge.length; index++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // BULLETS
                Container(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        child: VerticalDivider(
                          thickness: 1,
                          color: index == 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: index == 0 ? Colors.white : Colors.grey,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //border: Border.all(width: 1, color: Colors.grey),
                            color: index == listChallenge.length - 1 ? Colors.green : Colors.green),
                        child: Center(child: listChallenge[index].icon),
                      ),
                      Expanded(
                        child: VerticalDivider(
                          thickness: 1,
                          color: index == listChallenge.length - 1 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${listChallenge[index].title}',
                            style: GoogleFonts.kurale(color: Styles.textColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        // if (listChallenge[index].type == "sendChallenge" && listUserPosts == null)
                        //   Row(
                        //     children: [
                        //       Text('Бүтээл хийгээгүй байна!',
                        //           style: GoogleFonts.kurale(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                        //     ],
                        //   ),
                        if (listChallenge[index].type == "sendChallenge" &&
                            listUserPosts != null &&
                            app.challengeSubmit!.done! > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: WeeklyProgressBar(
                                      total: app.challengeSubmit!.total, done: app.challengeSubmit!.done, width: 230)),
                              Text("${app.challengeSubmit!.done}/${app.challengeSubmit!.total}",
                                  style: GoogleFonts.kurale(
                                    fontSize: 13,
                                    color: Styles.textColor,
                                    letterSpacing: 1,
                                  )),
                              SizedBox(width: 20),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  _noPostWarning() {
    return InkWell(
      onTap: () {
        baseFunctions.logCatcher(eventName: "Challenge_GotoActivity");
        Navigator.popAndPushNamed(context, '/activity_list', arguments: {
          'listType': app.activityTypes,
          'selectedType': null,
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(bottom: 20),
        height: 50,
        child: Row(
          children: [
            SizedBox(width: 5),
            Icon(Icons.info, size: 20, color: Styles.baseColor1.withOpacity(0.5)),
            SizedBox(width: 5),
            Text("Бүтээл байхгүй байна. Бүтээл хийх.",
                style: GoogleFonts.kurale(
                  color: Styles.baseColor1.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}
