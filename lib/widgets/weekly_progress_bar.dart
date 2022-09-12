import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class WeeklyProgressBar extends StatelessWidget {
  final int? total;
  final int? done;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;

  const WeeklyProgressBar({
    required this.total,
    required this.done,
    required this.width,
    this.height = 15,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: inactiveColor ?? Styles.baseColor1.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        Container(
          height: height,
          width: width * done! / total!,
          decoration: BoxDecoration(
            color: activeColor ?? Styles.baseColor1,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ],
    );
  }
}
