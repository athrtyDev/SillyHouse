import 'package:cached_network_image/cached_network_image.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/widgets/activity_type_widget.dart';
import 'package:sillyhouseorg/ui/widgets/on_image_text.dart';

class GalleryPostWidget extends StatefulWidget {
  final Post post;
  final bool isSelected;

  GalleryPostWidget({required this.post, this.isSelected = false});

  @override
  _GalleryPostWidgetState createState() => _GalleryPostWidgetState();
}

class _GalleryPostWidgetState extends State<GalleryPostWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        color: AppColors.whiteColor,
        child: Column(
          children: [
            // MEDIA
            Expanded(
                child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: widget.post.coverDownloadUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.post.coverDownloadUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            widget.isSelected ? _selectedOverlay() : SizedBox(),
                          ],
                        )
                      : Center(
                          child: Icon(Icons.ondemand_video, size: 70, color: Color(0xff36c1c8)),
                        ),
                ),
                // CHALLENGE NAME
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: OnImageText(text: widget.post.activity!.name),
                ),
              ],
            )),
            // CHALLENGE TYPE, DIFFICULTY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActivityTypeWidget(type: widget.post.activity!.activityType),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.post.isUserLiked) {
                        widget.post.dislikePost(widget.post, Provider.of<User>(context, listen: false).id);
                      } else {
                        widget.post.likePost(widget.post, Provider.of<User>(context, listen: false).id);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: 73,
                    height: 30,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.post.isUserLiked
                            ? Image.asset('lib/ui/images/icon_love_liked.png', height: 13)
                            : Image.asset('lib/ui/images/icon_love.png', height: 13),
                        SizedBox(width: 4),
                        Text(widget.post.likeCount == null ? '0' : widget.post.likeCount.toString(),
                            style: GoogleFonts.kurale(color: Colors.black54, fontSize: 16)),
                        SizedBox(width: 10),
                        Icon(Icons.comment, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                            (widget.post.listComment == null || widget.post.listComment!.isEmpty)
                                ? '0'
                                : widget.post.listComment!.length.toString(),
                            style: GoogleFonts.kurale(color: Colors.black54, fontSize: 16)),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
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
