import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/app/app_cubit.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/user_cubit.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/back_button.dart';
import 'package:sillyhouseorg/widgets/challenge_point.dart';
import 'package:sillyhouseorg/widgets/difficulty_level.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/my_media_player.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/rectangle_post.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ActivityInstructionScreen extends StatefulWidget {
  final Activity activity;

  ActivityInstructionScreen({required this.activity});

  @override
  _ActivityInstructionScreenState createState() => _ActivityInstructionScreenState();
}

class _ActivityInstructionScreenState extends State<ActivityInstructionScreen> {
  PostCubit postCubit = PostCubit();
  ScrollController? scrollViewController;
  int _carouselIndex = 0;
  bool isDynamicHeighSet = false;

  @override
  void initState() {
    super.initState();
    postCubit.getPostsOfActivity(widget.activity.id!);
    scrollViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: myAppBar(title: widget.activity.name!),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // _headerImage(),
              Container(
                margin: EdgeInsets.only(top: 0),
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  _instruction(),
                  SizedBox(height: 10),
                  _relatedPosts(),
                ]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _addPostButton());
  }

  Widget _headerImage() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: "activity${widget.activity.id}",
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.activity.coverImageUrl!,
              errorWidget: (context, url, error) => Icon(Icons.person_outline_rounded, size: 18),
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Utils.getActivityTypeColor(widget.activity.activityType!).withOpacity(0.5),
                  Utils.getActivityTypeColor(widget.activity.activityType!).withOpacity(0),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: MyBackButton(buttonColor: Styles.whiteColor),
          ),
        ),
      ],
    );
  }

  _instruction() {
    return Container(
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          // INSTRUCTION
          Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MyText.xlarge(widget.activity.name!),
                  MyText.large("Даалгавар"),
                  SizedBox(height: 10),
                  MyText.large(
                    widget.activity.instruction!,
                    textColor: Styles.textColor,
                    fontWeight: Styles.wNormal,
                  ),
                ],
              )),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DifficultyLevel(level: widget.activity.difficulty!),
                ChallengePoint(point: widget.activity.skill!),
              ],
            ),
          ),
          if (widget.activity.getListMedia()!.length != 1) SizedBox(height: 20),
          if (widget.activity.getListMedia()!.length != 1)
            Container(width: MediaQuery.of(context).size.width, height: 1, color: Styles.textColor10),
          SizedBox(height: 10),
          widget.activity.getListMedia() == null
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      widget.activity.getListMedia()!.length == 1
                          ? _mediaWidget(widget.activity.getListMedia()![0])
                          : Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 430,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enlargeCenterPage: false,
                                    autoPlay: false,
                                    reverse: false,
                                    enableInfiniteScroll: false,
                                    pauseAutoPlayOnTouch: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _carouselIndex = index;
                                        // _pauseVideos();
                                      });
                                    },
                                  ),
                                  items: widget.activity.getListMedia()!.map((media) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          child: MyText.large("Алхам - ${_carouselIndex + 1}"),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(child: _mediaWidget(media)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 10),
                                // progress circles
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(widget.activity.getListMedia()!.length, (index) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      width: _carouselIndex == index ? 20 : 10,
                                      height: 10.0,
                                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: _carouselIndex == index ? Styles.baseColor2 : Styles.textColor10,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
          // _activityDetail(),
        ],
      ),
    );
  }

  Widget _mediaWidget(Media media) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: MyMediaPlayer(
        url: media.url!,
        type: media.type!,
      ),
    );
  }

  _relatedPosts() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: postCubit,
      builder: (context, state) {
        if (state is PostLoaded && state.listPosts != null && state.listPosts!.isNotEmpty) {
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Styles.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: MyText.large('Бусад хүүхдийн бүтээлүүд'),
                ),
                SizedBox(height: 10),
                Container(
                  height: 230,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(4),
                  child: GridView.count(
                    controller: scrollViewController,
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 5.0,
                    children: state.listPosts!.map((Post post) {
                      return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              baseFunctions.logCatcher(eventName: "Post_View", properties: {
                                'activityName': post.activity!.name,
                                'userName': post.userName,
                              });
                              Navigator.pushNamed(context, '/post_detail', arguments: {'post': post});
                            },
                            child: RectanglePost(
                              imageUrl: post.coverDownloadUrl!,
                              leadingTitleWidget: Container(
                                height: 30,
                                width: 30,
                                child: ProfilePicture(url: post.userProfilePic),
                              ),
                              header: post.userName ?? "",
                              subHeader: Utils.convertDate(post.postDate.toString()),
                            ),
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else
          return SizedBox();
      },
    );
  }

  _addPostButton() {
    return Container(
      height: 75,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Styles.baseColor2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 23),
            SizedBox(width: 8),
            MyText.large('Бүтээлээ оруулах', textColor: Styles.whiteColor),
          ],
        ),
        onPressed: () {
          context.read<AppCubit>().pauseVideo();
          baseFunctions.logCatcher(
            eventName: "Activity_Instruction_Upload",
            properties: {'activity': widget.activity.name},
          );
          // _pauseVideos();
          Post post = new Post();
          //post.uploadMediaType = 'image';
          post.activity = widget.activity;
          post.user = context.read<UserCubit>().state.user!;
          post.pickedMedia = null;
          Navigator.pushNamed(context, '/publish', arguments: post);
        },
      ),
    );
  }
}
