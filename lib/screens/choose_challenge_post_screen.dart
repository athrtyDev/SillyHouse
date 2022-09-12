import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/challenge/cubit.dart';
import 'package:sillyhouseorg/bloc/user/user_cubit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/widgets/post_widget.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/weekly_progress_bar.dart';

class ChooseChallengePostScreen extends StatefulWidget {
  final List<Post>? listUserPost;

  ChooseChallengePostScreen({required this.listUserPost});

  @override
  _ChooseChallengePostScreenState createState() => _ChooseChallengePostScreenState();
}

class _ChooseChallengePostScreenState extends State<ChooseChallengePostScreen> {
  ChallengeCubit cubit = ChallengeCubit();
  ScrollController? scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    cubit.initChooseChallenge(widget.listUserPost);
  }

  @override
  void dispose() {
    scrollViewController!.dispose();
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
          title: Text("Бүтээл сонгох",
              style: GoogleFonts.kurale(
                fontSize: 18,
                color: Styles.textColor,
                fontWeight: FontWeight.w500,
              )),
        ),
        backgroundColor: Styles.backgroundColor,
        body: BlocBuilder<ChallengeCubit, ChallengeState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is ChooseChallengeLoaded) {
              return Column(children: <Widget>[
                Container(
                  color: Styles.whiteColor,
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
                                color: Styles.textColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              )),
                          Text("${state.listSelectedPost.length}/${app.challengeSubmit!.total}",
                              style: GoogleFonts.kurale(
                                fontSize: 15,
                                color: Styles.textColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              )),
                        ],
                      ),
                      SizedBox(height: 5),
                      WeeklyProgressBar(
                          total: app.challengeSubmit!.total,
                          done: state.listSelectedPost.length,
                          width: MediaQuery.of(context).size.width - 40,
                          height: 15),
                    ],
                  ),
                ),
                Expanded(
                  child: widget.listUserPost == null
                      ? Center(child: Image.asset('lib/assets/no_post.png', height: 350))
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
                              children: widget.listUserPost!.map((Post post) {
                                return PostWidget(
                                  post: post,
                                  isSelected: post.isSelected,
                                  onMediaTap: () {
                                    if (!post.isSelected && state.listSelectedPost.length >= app.challengeSubmit!.total!)
                                      Flushbar(
                                        message: 'Нийт ${app.challengeSubmit!.total} бүтээл илгээнэ.',
                                        padding: EdgeInsets.all(25),
                                        backgroundColor: Styles.baseColor1,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    else
                                      cubit.selectPost(post);
                                  },
                                  onCommentTap: () {},
                                  onLikeTap: () {},
                                );
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
                                    primary: Styles.baseColor1.withOpacity(0.9),
                                    elevation: 4.0,
                                  ),
                                  child: state.isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Илгээх', style: GoogleFonts.kurale(fontSize: 16, color: Styles.whiteColor)),
                                  onPressed: () async {
                                    if (!state.isLoading) {
                                      if (state.listSelectedPost.length == 0) {
                                        Flushbar(
                                          message: 'Бүтээлээ сонгоорой.',
                                          padding: EdgeInsets.all(25),
                                          backgroundColor: Styles.baseColor1,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      } else {
                                        await cubit.submitChallenge(context.read<UserCubit>().state.user!);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
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
}
