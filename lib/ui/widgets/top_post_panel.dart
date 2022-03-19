import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/story_type.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/viewmodels/post_stories_model.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:sillyhouseorg/ui/widgets/icon_and_text.dart';
import 'package:sillyhouseorg/ui/widgets/my_media.dart';
import 'package:sillyhouseorg/ui/widgets/my_story_view.dart';
import 'package:sillyhouseorg/ui/widgets/on_image_text.dart';

class TopPostPanel extends StatefulWidget {
  const TopPostPanel({Key key}) : super(key: key);

  @override
  _TopPostPanelState createState() => _TopPostPanelState();
}

class _TopPostPanelState extends State<TopPostPanel> with TickerProviderStateMixin {
  ScrollController scrollViewController;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    scrollViewController = ScrollController();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2.5).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    scrollViewController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PostStoriesModel>(
      onModelReady: (model) => model.getFeaturedPost(),
      builder: (context, model, child) => model.state == ViewState.Busy || model.listPost == null || model.listPost.isEmpty
          ? SizedBox()
          : Column(
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
                    children: model.listPost.map((Post post) {
                      return InkWell(
                        onTap: () {
                          showStoryDialog(model.listPost, post);
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
                                  imageUrl: post.coverDownloadUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              Positioned(
                                left: 5,
                                bottom: 5,
                                child: OnImageText(text: post.activity.name),
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
  }

  showStoryDialog(List<Post> listPost, Post post) {
    List<StoryType> listStoryType = List.generate(
      listPost.length,
      (index) => StoryType(
        media: MyMedia(url: listPost[index].coverDownloadUrl, type: listPost[index].uploadMediaType),
        title: listPost[index].activity.name,
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
