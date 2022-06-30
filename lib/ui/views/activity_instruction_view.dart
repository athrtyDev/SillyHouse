import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/like.dart';
import 'package:sillyhouseorg/core/classes/media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/services/tool.dart';
import 'package:sillyhouseorg/core/viewmodels/activity_instruction_model.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/ui/widgets/my_app_bar.dart';
import 'package:video_player/video_player.dart';

class ActivityInstructionView extends StatefulWidget {
  final Activity? activity;

  ActivityInstructionView({required this.activity});

  @override
  _ActivityInstructionViewState createState() => _ActivityInstructionViewState();
}

class _ActivityInstructionViewState extends State<ActivityInstructionView> {
  List<Post>? relatedPosts;
  final Api? _api = locator<Api>();
  ScrollController? scrollViewController;
  int _carouselIndex = 0;
  late bool mediaDownloadingState;

  @override
  void initState() {
    super.initState();
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
    return BaseView<ActivityInstructionModel>(
      onModelReady: (model) => getPosts(context),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          _disposeVideos();
          return new Future.value(true);
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
              appBar: myAppBar(
                leadingFunction: () => Navigator.of(context).pop(),
                title: widget.activity!.name,
              ) as PreferredSizeWidget?,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  _instruction(),
                  _relatedPosts(),
                ]),
              ),
              bottomNavigationBar: Container(
                height: 60,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.baseColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 23),
                      SizedBox(width: 8),
                      Text('Бүтээлээ оруулах', style: GoogleFonts.kurale(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  onPressed: () {
                    _pauseVideos();
                    Post post = new Post();
                    //post.uploadMediaType = 'image';
                    post.activity = widget.activity;
                    post.user = Provider.of<User>(context, listen: false);
                    post.pickedMedia = null;
                    Navigator.pushNamed(context, '/publish', arguments: post);
                  },
                ),
              )),
        ),
      ),
    );
  }

  _instruction() {
    return Column(
      children: [
        // INSTRUCTION
        Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Даалгавар:',
                    style:
                        GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                SizedBox(height: 5),
                Text(widget.activity!.instruction!,
                    style:
                        GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.5)),
              ],
            )),
        widget.activity!.getListMedia() == null
            ? SizedBox()
            : Container(
                height: widget.activity!.getListMedia()!.length == 1 ? 400 : 370,
                width: MediaQuery.of(context).size.width,
                child: mediaDownloadingState
                    ? Container(child: Center(child: CircularProgressIndicator()))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // progress circles
                          widget.activity!.getListMedia()!.length == 1
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(widget.activity!.getListMedia()!.length, (index) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                      width: _carouselIndex == index ? 20 : 10,
                                      height: 10.0,
                                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        color: _carouselIndex == index ? Colors.green : Colors.grey[400],
                                      ),
                                    );
                                  }),
                                ),
                          widget.activity!.getListMedia()!.length == 1
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: widget.activity!.getListMedia()!.length == 1 ? 400 : 330,
                              initialPage: 0,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              reverse: false,
                              enableInfiniteScroll: false,
                              autoPlayInterval: Duration(seconds: 2),
                              autoPlayAnimationDuration: Duration(milliseconds: 2000),
                              pauseAutoPlayOnTouch: true,
                              scrollDirection: widget.activity!.getListMedia()!.length == 1 ? Axis.vertical : Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _carouselIndex = index;
                                  _pauseVideos();
                                });
                              },
                            ),
                            items: widget.activity!.getListMedia()!.map((media) {
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
                                                              color: AppColors.whiteColor, size: 60),
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
        _activityDetail(),
      ],
    );
  }

  _activityDetail() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 60,
      child: Container(
        child: Column(
          children: [
            // DIY INFO
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // TYPE, XP points
                  Container(
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.all(7),
                      child: Container(
                          child: Row(
                        children: [
                          Image.asset("lib/ui/images/icon_do_it.png", height: 25),
                          Column(
                            children: [
                              /*Text(widget.activity.activityType == 'diy' ? 'Бүтээл' : (widget.activity.activityType == 'discover' ? 'Өөрийгөө нээ' : (widget.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                      style: GoogleFonts.kurale(color: Colors.black45)),*/
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 4, 0, 4),
                                decoration:
                                    BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Text('+' + widget.activity!.skill.toString() + ' оноо',
                                    style: GoogleFonts.kurale(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )
                        ],
                      ))),
                  SizedBox(width: 25),
                  // DIFFICULTY LEVEL
                  Container(
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 3),
                          child: widget.activity!.difficulty == 'easy'
                              ? Image.asset('lib/ui/images/icon_easy.png', height: 25)
                              : (widget.activity!.difficulty == 'medium'
                                  ? Image.asset('lib/ui/images/icon_medium.png', height: 25)
                                  : (widget.activity!.difficulty == 'hard'
                                      ? Image.asset('lib/ui/images/icon_hard.png', height: 25)
                                      : Text(''))),
                        ),
                        Text(
                            widget.activity!.difficulty == 'easy'
                                ? 'Амархан'
                                : (widget.activity!.difficulty == 'medium'
                                    ? 'Дунд зэрэг'
                                    : (widget.activity!.difficulty == 'hard' ? 'Хэцүү' : Text('') as String)),
                            style: GoogleFonts.kurale(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _relatedPosts() {
    return relatedPosts == null
        ? Container()
        : Column(
            children: [
              Container(
                height: 5,
                color: Colors.grey[200],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                alignment: Alignment.centerLeft,
                child: Text('Бусад хүүхдийн бүтээлүүд',
                    style:
                        GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              ),
              Container(
                height: 230,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(4),
                child: GridView.count(
                  controller: scrollViewController,
                  crossAxisCount: 1,
                  //childAspectRatio: 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  mainAxisSpacing: 5.0,
                  children: relatedPosts!.map((Post post) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pushNamed(context, '/post_detail', arguments: post).then((value) => setState(() {}));
                          });
                        },
                        child: Stack(children: [
                          // IMAGE, VIDEO
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Container(
                                        width: 230,
                                        child: post.uploadMediaType == 'image'
                                            ? (post.mediaDownloadUrl != null
                                                ? Image.network(post.mediaDownloadUrl!, fit: BoxFit.cover)
                                                : Center(child: Icon(Icons.error, size: 20)))
                                            : (post.coverDownloadUrl != null
                                                ? Image.network(post.coverDownloadUrl!, fit: BoxFit.cover)
                                                : Center(
                                                    child: Icon(
                                                    Icons.ondemand_video,
                                                    size: 70,
                                                    color: Color(0xff36c1c8),
                                                  ))))),
                              ],
                            ),
                          ),
                          // POSTED USER
                          Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.pink.withOpacity(0.7)),
                                ),
                                padding: EdgeInsets.all(2),
                                //width: 40,
                                height: 25,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.black54, size: 15),
                                      SizedBox(width: 3),
                                      Text(post.userName!,
                                          style: GoogleFonts.kurale(
                                              fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              )),
                        ]));
                  }).toList(),
                ),
              ),
            ],
          );
  }

  _disposeVideos() {
    if (widget.activity!.getListMedia() != null && widget.activity!.getListMedia()!.isNotEmpty) {
      for (Media media in widget.activity!.getListMedia()!) {
        if (media.type == 'video') media.videoController.dispose();
      }
    }
  }

  _pauseVideos() {
    if (widget.activity!.getListMedia() != null && widget.activity!.getListMedia()!.isNotEmpty) {
      for (Media media in widget.activity!.getListMedia()!) {
        if (media.type == 'video' && media.videoController.value.isPlaying) media.videoController.pause();
      }
    }
  }

  void getDiyInstruction() async {
    try {
      setState(() {
        mediaDownloadingState = true;
      });
      if (widget.activity!.getListMedia() != null && widget.activity!.getListMedia()!.isNotEmpty) {
        int mediaCount = 0;
        int videoCount = 0;
        late String cachePath;
        if (Platform.isAndroid) {
          var cacheDir = await (getExternalCacheDirectories() as FutureOr<List<Directory>>);
          cachePath = cacheDir.first.path;
        }
        var dio = Dio();
        for (Media media in widget.activity!.getListMedia()!) {
          // save to cache
          mediaCount++;
          if (Platform.isAndroid) media.cachePath = await Tool.cacheMedia(widget.activity!, media, mediaCount, cachePath, dio);

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
              if (videoCount == 1 && widget.activity!.autoPlay!) media.videoController.play();
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

  void getPosts(BuildContext context) async {
    try {
      User loggedUser = Provider.of<User>(context, listen: false);
      relatedPosts = await _api!.getPostByActivity(widget.activity!);
      List<Like>? allLikes = await _api!.getAllLikes();

      setState(() {
        if (relatedPosts != null && allLikes != null) {
          for (Like like in allLikes) {
            for (Post post in relatedPosts!) {
              // Count every post's like
              if (like.postId == post.postId) {
                if (post.likeCount == null) post.likeCount = 0;
                post.likeCount = post.likeCount! + 1;
              }
              // Check if logged user liked the post
              if (post.isUserLiked == null) post.isUserLiked = false;
              if (like.postId == post.postId && like.likedUserId == loggedUser.id) {
                post.isUserLiked = true;
              }
            }
          }
        }
      });
    } catch (ex) {
      print('error on getPost for selected activity: ' + ex.toString());
    }
  }
}
