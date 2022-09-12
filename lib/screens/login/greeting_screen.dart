import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class GreetingScreen extends StatefulWidget {
  @override
  _GreetingScreenState createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: Styles.whiteColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: 0.4,
                child: Image.asset('lib/assets/login_background.png', fit: BoxFit.cover),
              ),
              Container(
                color: Colors.white.withOpacity(0.3),
                child: Column(
                  children: [
                    SizedBox(height: 200),
                    _headerText(),
                    Expanded(child: SizedBox()),
                    _loginButtons(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _headerText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('lib/assets/home_header.svg', height: 40),
        SizedBox(height: 10),
        MyText.large(
          "Бүтээлч хүүхдүүдийн нэгдэл",
        ),
      ],
    );
  }

  _loginButtons() {
    return Padding(
      padding: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/login'),
            child: Container(
              width: 230,
              height: 50,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(
                color: Styles.baseColor2,
                border: Border.all(color: Styles.baseColor1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: MyText('Нэвтрэх', textColor: Styles.whiteColor),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/register'),
            child: Container(
              width: 230,
              height: 50,
              alignment: Alignment(0, 0),
              decoration: BoxDecoration(
                color: Styles.whiteColor,
                border: Border.all(color: Styles.baseColor2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: MyText('Бүртгүүлэх'),
            ),
          ),
        ],
      ),
    );
  }
}
