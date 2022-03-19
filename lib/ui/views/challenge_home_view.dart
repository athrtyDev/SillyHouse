import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/classes/weekly_challenge.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/viewmodels/challenge_home_model.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/widgets/my_media.dart';
import 'package:sillyhouseorg/ui/widgets/weekly_progress_bar.dart';

class ChallengeHomeView extends StatefulWidget {
  @override
  _ChallengeHomeViewState createState() => _ChallengeHomeViewState();
}

class _ChallengeHomeViewState extends State<ChallengeHomeView> {
  List<Post> relatedPosts;
  ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ChallengeHomeModel>(
      onModelReady: (model) => model.initData(Provider.of<User>(context, listen: false)),
      builder: (context, model, child) => SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.mainTextColor),
            ),
            title: Text("Шагналт тэмцээн",
                style: GoogleFonts.kurale(
                  fontSize: 18,
                  color: AppColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                )),
          ),
          backgroundColor: Colors.white,
          body: Column(children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: MyMedia(
                url:
                    "https://firebasestorage.googleapis.com/v0/b/education-69b9a.appspot.com/o/activity_diy%2Frainbow%20tissue%2Frainbow.mov?alt=media&token=67373a92-b771-42f5-b921-f2dc599d533b",
                type: "video",
              ),
            ),
            _infoHeader(),
            _stepperInstruction(model.listChallenge, model.listUserPosts),
            Expanded(child: SizedBox()),
            model.listUserPosts == null && model.state == ViewState.Idle ? _noPostWarning() : SizedBox(),
            model.state == ViewState.Busy
                ? SizedBox()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.only(bottom: 30),
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: model.listUserPosts == null ? Colors.blueGrey.shade100 : AppColors.baseColor,
                        elevation: 4.0,
                      ),
                      child: Text('Тэмцээнд оролцох', style: GoogleFonts.kurale(fontSize: 16)),
                      onPressed: () {
                        if (model.listUserPosts == null)
                          Flushbar(
                            message: 'Бүтээл хийгээгүй байна.',
                            padding: EdgeInsets.all(25),
                            backgroundColor: Color(0xff36c1c8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        else
                          Navigator.popAndPushNamed(context, '/choose_challenge_post', arguments: model.listUserPosts);
                      },
                    ),
                  ),
          ]),
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
                    Icon(Icons.info_outline, size: 20, color: AppColors.mainTextColor),
                    SizedBox(width: 5),
                    Text("Тэмцээнд оролцож дээрх шагналыг хожоорой.",
                        style: GoogleFonts.kurale(color: AppColors.mainTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            )),
      ],
    );
  }

  _stepperInstruction(List<WeeklyChallenge> listChallenge, List<Post> listUserPosts) {
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
                            style: GoogleFonts.kurale(color: AppColors.mainTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        if (listChallenge[index].type == "sendChallenge" && listUserPosts == null)
                          Row(
                            children: [
                              Text('Бүтээл хийгээгүй байна!',
                                  style: GoogleFonts.kurale(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        if (listChallenge[index].type == "sendChallenge" && listUserPosts != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: WeeklyProgressBar(
                                      total: app.challengeSubmit.total, done: app.challengeSubmit.done, width: 230)),
                              Text("${app.challengeSubmit.done}/${app.challengeSubmit.total}",
                                  style: GoogleFonts.kurale(
                                    fontSize: 13,
                                    color: AppColors.mainTextColor,
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
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(bottom: 20),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.whiteColor,
              side: BorderSide(color: AppColors.baseColor.withOpacity(0.4)),
              elevation: 4.0,
            ),
            child: Text('Бүтээл хийх', style: GoogleFonts.kurale(fontSize: 16, color: AppColors.baseColor)),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/activity_list', arguments: {
                'listType': app.activityTypes,
                'selectedType': null,
              });
            },
          ),
        ),
      ],
    );
  }
}
