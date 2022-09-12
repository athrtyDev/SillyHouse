import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/button.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
        return new Future.value(true);
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/coming_soon.png",
              height: 300,
              width: 300,
            ),
            MyText.xlarge("Тун удахгүй"),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
