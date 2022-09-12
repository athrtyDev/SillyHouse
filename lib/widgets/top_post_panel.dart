import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/user_cubit.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/story_type.dart';
import 'package:sillyhouseorg/global/base_functions.dart';
import 'package:sillyhouseorg/widgets/icon_and_text.dart';
import 'package:sillyhouseorg/widgets/my_media.dart';
import 'package:sillyhouseorg/widgets/my_story_view.dart';
import 'package:sillyhouseorg/widgets/on_image_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class TopPostPanel extends StatefulWidget {
  const TopPostPanel({Key? key}) : super(key: key);

  @override
  _TopPostPanelState createState() => _TopPostPanelState();
}

class _TopPostPanelState extends State<TopPostPanel> with TickerProviderStateMixin {
  PostCubit cubit = PostCubit();
  ScrollController? scrollViewController = ScrollController();
  late AnimationController _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  late Animation _animation;

  @override
  void initState() {
    cubit.getStory(context.read<UserCubit>().state.user!.id!);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2.5).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollViewController!.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is PostLoaded && state.listPosts != null) {
          return Container(
            color: Styles.whiteColor,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconAndText(icon: Icon(Icons.star, color: Colors.amber, size: 23), text: "Өнгөрсөн 7 хоногийн ялагчид"),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  alignment: Alignment(-1, 0),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: GridView.count(
                    controller: scrollViewController,
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    childAspectRatio: 1.25,
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 5,
                    children: state.listPosts!.map((Post post) {
                      return InkWell(
                        onTap: () {
                          baseFunctions.logCatcher(eventName: "Story_Show");
                          showStoryDialog(state.listPosts!, post);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Colors.orange, width: 0.5),
                            boxShadow: [
                              BoxShadow(color: Colors.orange, blurRadius: _animation.value, spreadRadius: _animation.value)
                            ],
                          ),
                          margin: EdgeInsets.all(1.5),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: CachedNetworkImage(
                                  imageUrl: post.coverDownloadUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              Positioned(
                                left: 5,
                                bottom: 5,
                                child: OnImageText(text: post.activity!.name),
                              ),
                            ],
                          ),
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

  showStoryDialog(List<Post> listPost, Post post) {
    List<StoryType> listStoryType = List.generate(
      listPost.length,
      (index) => StoryType(
        media: MyMedia(url: listPost[index].coverDownloadUrl!, type: listPost[index].uploadMediaType!),
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
