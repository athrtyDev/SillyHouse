import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double height;
  const Loader({this.height = 70});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "lib/assets/loader.gif",
        height: height,
      ),
    );
  }
}
