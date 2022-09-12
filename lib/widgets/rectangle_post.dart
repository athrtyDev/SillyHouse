import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class RectanglePost extends StatelessWidget {
  final String imageUrl;
  final Widget? leadingTitleWidget;
  final String header;
  final String subHeader;
  final Widget? bottomWidget;

  const RectanglePost({
    Key? key,
    required this.imageUrl,
    this.leadingTitleWidget,
    required this.header,
    required this.subHeader,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ],
        ),
        // HEADER SHADOW
        Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.6),
                ],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        // USER INFO
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: [
              if (leadingTitleWidget != null) leadingTitleWidget!,
              if (leadingTitleWidget != null) SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.medium(header, textColor: Styles.whiteColor, fontWeight: Styles.wBold),
                  MyText.small(subHeader, textColor: Styles.whiteColor70, fontWeight: Styles.wBold),
                ],
              )
            ],
          ),
        ),
        if (bottomWidget != null)
          Positioned(
            bottom: 0,
            child: bottomWidget!,
          ),
      ],
    );
  }
}
