import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ChallengePoint extends StatelessWidget {
  final int point;
  const ChallengePoint({Key? key, required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Styles.baseColor2,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: MyText("+$point оноо", textColor: Styles.whiteColor, fontWeight: Styles.wBold),
    );
  }
}
