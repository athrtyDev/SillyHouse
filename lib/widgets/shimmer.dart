import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder? shapeBorder;
  final double? borderRadius;
  final bool? isAlert;
  final Color? color;

  const ShimmerWidget({Key? key, this.width, this.height, this.shapeBorder, this.borderRadius, this.isAlert, this.color})
      : super(key: key);

  const ShimmerWidget.rectangular({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 0,
    this.isAlert = false,
    this.color,
  })  : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  const ShimmerWidget.circular(
      {Key? key,
      required this.width,
      required this.height,
      this.borderRadius = 0,
      this.isAlert = false,
      this.color,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: color ?? Colors.grey[100]!,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius!),
          child: Container(
            width: width,
            height: height,
            decoration: ShapeDecoration(color: color ?? Colors.grey[200], shape: shapeBorder!),
          )));
}
