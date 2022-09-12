import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.whiteColor,
      padding: EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Flushbar(
                message: 'Өөө, хийхээ мартчиж...',
                padding: EdgeInsets.all(25),
                backgroundColor: Styles.baseColor1,
                duration: Duration(seconds: 3),
              )..show(context);
            },
            child: SvgPicture.asset('lib/assets/left_menu.svg', height: 40),
          ),
          SvgPicture.asset('lib/assets/home_header.svg'),
          InkWell(
            onTap: () {
              Flushbar(
                message: 'Өөө, хийхээ мартчиж...',
                padding: EdgeInsets.all(25),
                backgroundColor: Styles.baseColor1,
                duration: Duration(seconds: 3),
              )..show(context);
            },
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Styles.baseColor3,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: SvgPicture.asset('lib/assets/bell.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
