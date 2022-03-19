import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/viewmodels/choose_challenge_model.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/widgets/gallery_post_widget.dart';
import 'package:sillyhouseorg/ui/widgets/weekly_progress_bar.dart';

class ChooseChallengePostView extends StatefulWidget {
  final List<Post> listUserPost;

  ChooseChallengePostView({@required this.listUserPost});

  @override
  _ChooseChallengePostViewState createState() => _ChooseChallengePostViewState();
}

class _ChooseChallengePostViewState extends State<ChooseChallengePostView> {
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
    return BaseView<ChooseChallengeModel>(
      onModelReady: (model) => model.initData(widget.listUserPost),
      builder: (context, model, child) => SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.mainTextColor),
            ),
            title: Text("Бүтээл сонгох",
                style: GoogleFonts.kurale(
                  fontSize: 18,
                  color: AppColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                )),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Column(children: <Widget>[
            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Илгээсэн даалгавар:',
                          style: GoogleFonts.kurale(
                            fontSize: 15,
                            color: AppColors.mainTextColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          )),
                      Text("${model.listSelectedPost.length}/${app.challengeSubmit.total}",
                          style: GoogleFonts.kurale(
                            fontSize: 15,
                            color: AppColors.mainTextColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  WeeklyProgressBar(
                      total: app.challengeSubmit.total,
                      done: model.listSelectedPost.length,
                      width: MediaQuery.of(context).size.width - 40,
                      height: 15),
                ],
              ),
            ),
            Expanded(
              child: widget.listUserPost == null
                  ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350))
                  : Stack(
                      children: [
                        GridView.count(
                          controller: scrollViewController,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 0.75,
                          scrollDirection: Axis.vertical,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 8,
                          children: widget.listUserPost.map((Post post) {
                            return GestureDetector(
                                onTap: () {
                                  if (!post.isSelected && model.listSelectedPost.length >= app.challengeSubmit.total)
                                    Flushbar(
                                      message: 'Нийт ${app.challengeSubmit.total} бүтээл илгээнэ.',
                                      padding: EdgeInsets.all(25),
                                      backgroundColor: Color(0xff36c1c8),
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  else
                                    model.selectPost(post);
                                },
                                child: GalleryPostWidget(post: post, isSelected: post.isSelected));
                          }).toList(),
                        ),
                        Positioned(
                          bottom: 20,
                          left: MediaQuery.of(context).size.width * 0.05,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.baseColor.withOpacity(0.9),
                                elevation: 4.0,
                              ),
                              child: model.state == ViewState.Idle
                                  ? Text('Илгээх', style: GoogleFonts.kurale(fontSize: 16, color: AppColors.whiteColor))
                                  : CircularProgressIndicator(),
                              onPressed: () async {
                                if (model.state == ViewState.Idle) {
                                  await model.submitChallenge(Provider.of<User>(context, listen: false));
                                  Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
