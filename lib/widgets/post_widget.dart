import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/rectangle_post.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final Function? onMediaTap;
  final Function onCommentTap;
  final Function onLikeTap;
  final double heightIndex;
  final bool? fromTappingComment;
  final bool isSelected;

  PostWidget({
    required this.post,
    this.onMediaTap,
    required this.onCommentTap,
    required this.onLikeTap,
    this.heightIndex = 1,
    this.fromTappingComment = false,
    this.isSelected = false,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late Post post;

  @override
  void initState() {
    post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.width - 20) * widget.heightIndex,
      color: Styles.whiteColor,
      child: Column(
        children: [
          // MEDIA
          Expanded(
              child: InkWell(
            onTap: () {
              if (widget.onMediaTap != null) {
                widget.onMediaTap!();
              }
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
              // description: widget.showBottom ? post.activity!.name! : "",
              // descColor: widget.showBottom ? Utils.getActivityTypeColor(post.activity!.activityType!) : Colors.transparent,
              bottomWidget: _postBottomWidget(),
              isSelfie: post.isSelfie != null && post.isSelfie!,
            ),
          )),
        ],
      ),
    );
  }

  _postBottomWidget() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width - 20,
      alignment: Alignment(0, 1),
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Utils.getActivityTypeColor(post.activity!.activityType!).withOpacity(0.5),
              Utils.getActivityTypeColor(post.activity!.activityType!).withOpacity(0.3),
              Utils.getActivityTypeColor(post.activity!.activityType!).withOpacity(0),
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText.medium(
                post.activity!.name!,
                textColor: Styles.whiteColor,
                fontWeight: Styles.wBold,
              ),
              MyText.small("Төрөл: ${Utils.getActivityTypeName(post.activity!.activityType!).name!}",
                  textColor: Styles.whiteColor70),
            ],
          ),
          Expanded(child: SizedBox()),
          Row(
            children: [
              InkWell(
                onTap: () {
                  widget.onCommentTap();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset('lib/assets/comment.svg', color: Styles.whiteColor),
                      SizedBox(width: 8),
                      MyText.medium(
                        post.commentCount.toString(),
                        fontWeight: Styles.wBold,
                        textColor: Styles.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onLikeTap();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'lib/assets/heart.svg',
                        color: post.isUserLiked ? Styles.baseColor3 : Styles.whiteColor,
                      ),
                      SizedBox(width: 8),
                      MyText.medium(
                        post.likeCount.toString(),
                        fontWeight: Styles.wBold,
                        textColor: post.isUserLiked ? Styles.baseColor3 : Styles.whiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _selectedOverlay() {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Icon(Icons.done, color: Colors.white, size: 15),
            ),
          ),
        ),
      ],
    );
  }
}
