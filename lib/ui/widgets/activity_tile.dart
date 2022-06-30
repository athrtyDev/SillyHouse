import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/widgets/activity_type_widget.dart';
import 'package:sillyhouseorg/ui/widgets/on_image_text.dart';
import 'package:sillyhouseorg/utils/utils.dart';

class ActivityTile extends StatelessWidget {
  final Activity? activity;
  final Function? onTap;
  final Color? color;

  const ActivityTile({Key? key, this.activity, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap as void Function()?,
      child: Container(
        width: (MediaQuery.of(context).size.width) / 2,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(13)),
          color: this.color,
        ),
        child: Column(
          children: [
            Expanded(
                child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                    width: (MediaQuery.of(context).size.width),
                    child: activity!.cachePathCoverImg != null
                        ? (ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                            child: Image.file(File(activity!.cachePathCoverImg!), fit: BoxFit.fitWidth),
                          ))
                        : (activity!.coverImageUrl == null
                            ? Center(child: CircularProgressIndicator())
                            : ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                                child: CachedNetworkImage(
                                  imageUrl: activity!.coverImageUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                                // Image.network(activity.coverImageUrl, fit: BoxFit.fill),
                              ))),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: OnImageText(text: Utils.getActivityTypeName(activity!.activityType).name),
                )
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //ActivityTypeWidget(type: activity.activityType),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(activity!.name!,
                      style: GoogleFonts.kurale(fontSize: 12, color: AppColors.textColor70, fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 3),
                  child: activity!.difficulty == 'easy'
                      ? Image.asset('lib/ui/images/icon_easy.png', height: 20)
                      : (activity!.difficulty == 'medium'
                          ? Image.asset('lib/ui/images/icon_medium.png', height: 20)
                          : (activity!.difficulty == 'hard' ? Image.asset('lib/ui/images/icon_hard.png', height: 20) : Text(''))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
