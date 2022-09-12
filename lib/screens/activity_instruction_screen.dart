import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/user_cubit.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/services/tool.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/widgets/challenge_point.dart';
import 'package:sillyhouseorg/widgets/difficulty_level.dart';
import 'package:sillyhouseorg/widgets/loader.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/post_widget.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:video_player/video_player.dart';

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
  late bool mediaDownloadingState;

  @override
  void initState() {
    super.initState();
    postCubit.getPostsOfActivity(widget.activity.id!);
    mediaDownloadingState = true;
    scrollViewController = ScrollController();
    getDiyInstruction();
  }

  @override
  void dispose() {
    _disposeVideos();
    scrollViewController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _disposeVideos();
        return new Future.value(true);
      },
      child: Scaffold(
          appBar: myAppBar(
            leadingFunction: () => Navigator.of(context).pop(),
            title: widget.activity.name,
          ),
          backgroundColor: Styles.backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                _instruction(),
                SizedBox(height: 10),
                _relatedPosts(),
              ]),
            ),
          ),
          bottomNavigationBar: Container(
            height: 85,
            padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
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
                baseFunctions.logCatcher(
                  eventName: "Activity_Instruction_Upload",
                  properties: {'activity': widget.activity.name},
                );
                _pauseVideos();
                Post post = new Post();
                //post.uploadMediaType = 'image';
                post.activity = widget.activity;
                post.user = context.read<UserCubit>().state.user!;
                post.pickedMedia = null;
                Navigator.pushNamed(context, '/publish', arguments: post);
              },
            ),
          )),
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
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.large('Даалгавар'),
                  SizedBox(height: 10),
                  MyText.large(
                    widget.activity.instruction!,
                    textColor: Styles.textColor,
                    fontWeight: Styles.wNormal,
                  ),
                ],
              )),
          widget.activity.getListMedia() == null
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: mediaDownloadingState
                      ? Container(height: 400, child: Loader())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            // progress circles
                            widget.activity.getListMedia()!.length == 1
                                ? Container()
                                : Row(
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
                            widget.activity.getListMedia()!.length == 1
                                ? Container()
                                : SizedBox(
                                    height: 10,
                                  ),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: widget.activity.getListMedia()!.length == 1 ? 400 : 330,
                                initialPage: 0,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                reverse: false,
                                enableInfiniteScroll: false,
                                autoPlayInterval: Duration(seconds: 2),
                                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                pauseAutoPlayOnTouch: true,
                                scrollDirection: widget.activity.getListMedia()!.length == 1 ? Axis.vertical : Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _carouselIndex = index;
                                    _pauseVideos();
                                  });
                                },
                              ),
                              items: widget.activity.getListMedia()!.map((media) {
                                return Builder(
                                  builder: (BuildContext mediaContext) {
                                    return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                                        child: media.type == 'video'
                                            ?
                                            // VIDEO
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (media.videoController.value.isPlaying)
                                                      media.videoController.pause();
                                                    else
                                                      media.videoController.play();
                                                  });
                                                },
                                                child: Stack(
                                                  children: [
                                                    VideoPlayer(media.videoController),
                                                    // Play button
                                                    media.videoController.value.isPlaying
                                                        ? SizedBox()
                                                        : Center(
                                                            child: Icon(Icons.play_circle_filled,
                                                                color: Styles.whiteColor, size: 60),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            :
                                            // IMAGE
                                            media.cachePath == null
                                                ? CachedNetworkImage(
                                                    imageUrl: media.url!,
                                                    fit: BoxFit.fill,
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  )
                                                : Image.file(File(media.cachePath!), fit: BoxFit.fill));
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                ),
          // _activityDetail(),
        ],
      ),
    );
  }

  _activityDetail() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DifficultyLevel(level: widget.activity.difficulty!),
          ChallengePoint(point: widget.activity.skill!),
        ],
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
                        child: PostWidget(
                          post: post,
                          onMediaTap: () async {
                            baseFunctions.logCatcher(eventName: "Post_View", properties: {
                              'activityName': post.activity!.name,
                              'userName': post.userName,
                            });
                            Navigator.pushNamed(context, '/post_detail', arguments: {'post': post});
                          },
                          onLikeTap: () {},
                          onCommentTap: () {},
                        ),
                      );
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

  _disposeVideos() {
    if (widget.activity.getListMedia() != null && widget.activity.getListMedia()!.isNotEmpty) {
      for (Media media in widget.activity.getListMedia()!) {
        if (media.type == 'video') media.videoController.dispose();
      }
    }
  }

  _pauseVideos() {
    if (widget.activity.getListMedia() != null && widget.activity.getListMedia()!.isNotEmpty) {
      for (Media media in widget.activity.getListMedia()!) {
        if (media.type == 'video' && media.videoController.value.isPlaying) media.videoController.pause();
      }
    }
  }

  void getDiyInstruction() async {
    try {
      setState(() {
        mediaDownloadingState = true;
      });
      if (widget.activity.getListMedia() != null && widget.activity.getListMedia()!.isNotEmpty) {
        int mediaCount = 0;
        int videoCount = 0;
        late String cachePath;
        if (Platform.isAndroid) {
          var cacheDir = await (getExternalCacheDirectories() as Future<List<Directory>?>);
          cachePath = cacheDir!.first.path;
        }
        var dio = Dio();
        for (Media media in widget.activity.getListMedia()!) {
          // save to cache
          mediaCount++;
          if (Platform.isAndroid) media.cachePath = await Tool.cacheMedia(widget.activity, media, mediaCount, cachePath, dio);

          // IF video => initialize player
          if (media.type == 'video') {
            setState(() {
              videoCount++;
              //VideoPlayerController videoController = VideoPlayerController.network(media.url);
              VideoPlayerController videoController;
              if (media.cachePath == null)
                videoController = VideoPlayerController.network(media.url!);
              else
                videoController = VideoPlayerController.file(File(media.cachePath!));
              media.videoController = videoController;
              Future<void> initializeVideoPlayer = videoController.initialize();
              media.initializeVideoPlayer = initializeVideoPlayer;
              media.videoController.setLooping(false);
              media.videoController.setVolume(4.0);
              if (videoCount == 1 && widget.activity.autoPlay!) media.videoController.play();
            });
          }
        }
      }
      setState(() {
        mediaDownloadingState = false;
      });
    } catch (ex) {
      print('error on loadInstructions: ' + ex.toString());
    }
  }
}
