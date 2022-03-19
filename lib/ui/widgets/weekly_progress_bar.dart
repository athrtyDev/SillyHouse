import 'package:flutter/material.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';

class WeeklyProgressBar extends StatelessWidget {
  final int total;
  final int done;
  final double width;
  final double height;

  const WeeklyProgressBar({@required this.total, @required this.done, @required this.width, this.height = 15});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.baseColor.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        Container(
          height: height,
          width: width * done / total,
          decoration: BoxDecoration(
            color: AppColors.baseColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ],
    );
  }
}
