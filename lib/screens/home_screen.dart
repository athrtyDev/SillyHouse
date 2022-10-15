import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/story_type.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/widgets/home_header.dart';
import 'package:sillyhouseorg/widgets/post_widget.dart';
import 'package:sillyhouseorg/widgets/my_media_player.dart';
import 'package:sillyhouseorg/widgets/my_story_view.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/shimmer.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PostCubit cubit;
  late User user;
  late ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state.user!;
    cubit = context.read<PostCubit>();
    // cubit.initHomePost(user.id!);
    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.backgroundColor,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(),
            _stories(),
            _postFeed(),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  void scrollListener() {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      cubit.moreHomePost();
    }
  }

  Widget _postFeed() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is PostHomeLoaded && state.listPost != null) {
          return Container(
            color: Styles.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MyText.large("Сүүлд нэмэгдсэн бүтээлүүд"),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      for (var item in state.listPost!)
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: PostWidget(
                              post: item,
                              onMediaTap: () async {
                                baseFunctions.logCatcher(eventName: "Post_View", properties: {
                                  'activityName': item.activity!.name,
                                  'userName': item.userName,
                                });
                                dynamic postRes = await Navigator.pushNamed(context, '/post_detail', arguments: {'post': item});

                                if (postRes != null) {
                                  cubit.updateHomePost(postRes['post']);
                                }
                              },
                              onLikeTap: () {
                                cubit.likeHomePost(item, context.read<UserCubit>().state.user!.id!);
                              },
                              onCommentTap: () async {
                                baseFunctions.logCatcher(eventName: "Post_View", properties: {
                                  'activityName': item.activity!.name,
                                  'userName': item.userName,
                                });
                                dynamic postRes = await Navigator.pushNamed(context, '/post_detail', arguments: {
                                  'post': item,
                                  'fromTappingComment': true,
                                });
                                if (postRes != null) {
                                  cubit.updateHomePost(postRes['post']);
                                }
                              },
                            ),
                          ),
                        ),
                      if (state.isLoading) CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is PostLoading) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyText.large("Сүүлд нэмэгдсэн бүтээлүүд"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ShimmerWidget.rectangular(height: 300),
                    SizedBox(height: 10),
                    ShimmerWidget.rectangular(height: 300),
                    SizedBox(height: 10),
                    ShimmerWidget.rectangular(height: 300),
                    SizedBox(height: 10),
                    ShimmerWidget.rectangular(height: 300),
                  ],
                ),
              )
            ],
          );
        } else
          return SizedBox();
      },
    );
  }

  Widget _stories() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is PostHomeLoaded && state.listFeaturedPost != null) {
          return Container(
            color: Styles.backgroundColor,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                MyText.large("Өнөөдрийн шилдгүүд"),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var item in state.listFeaturedPost!) _storyItem(item, state.listFeaturedPost!),
                    ],
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

  Widget _storyItem(Post post, List<Post> listAll) {
    return Stack(
      children: [
        Container(
          height: 55,
          width: 55,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Styles.baseColor3, width: 2),
          ),
          child: ProfilePicture(
            url: post.userProfilePic,
            onTap: () {
              baseFunctions.logCatcher(eventName: "Story_Show");
              showStoryDialog(listAll, post);
            },
          ),
        ),
        if (post.likeCount > 0)
          Positioned(
            bottom: 0,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              decoration: BoxDecoration(
                color: Styles.baseColor3,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.5),
                    child: SvgPicture.asset(
                      'lib/assets/heart_small.svg',
                      color: Styles.whiteColor,
                      height: 13,
                    ),
                  ),
                  SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.5),
                    child: MyText.small(
                      post.likeCount.toString(),
                      fontWeight: Styles.wBold,
                      textColor: Styles.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  showStoryDialog(List<Post> listPost, Post post) {
    List<StoryType> listStoryType = List.generate(
      listPost.length,
      (index) => StoryType(
        media: MyMediaPlayer(url: listPost[index].coverDownloadUrl!, type: listPost[index].uploadMediaType!),
        title: listPost[index].activity!.name,
      ),
    );
    int startingIndex = 0;
    for (var item in listPost) {
      if (item.postId == post.postId)
        break;
      else
        startingIndex++;
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return MyStoryView(listStoryType: listStoryType, startingIndex: startingIndex);
        });
  }
}
