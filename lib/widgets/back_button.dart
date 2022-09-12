import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'dart:math' as math;

class MyBackButton extends StatelessWidget {
  final Color? buttonColor;
  const MyBackButton({Key? key, this.buttonColor = Styles.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: FittedBox(
        fit: BoxFit.none,
        child: Container(
          color: Styles.textColor05,
          height: 43,
          width: 43,
          alignment: Alignment(0, 0),
          child: Transform.rotate(
            angle: 90 * math.pi / 90,
            child: SvgPicture.asset(
              'lib/assets/arrow.svg',
              color: buttonColor,
              height: 25,
              width: 25,
            ),
          ),
        ),
      ),
    );
  }
}
