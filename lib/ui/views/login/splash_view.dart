import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/viewmodels/splash_model.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SplashModel>(
      onModelReady: (model) => model.initData(context),
      builder: (context, model, child) => Scaffold(
        body: Stack(fit: StackFit.expand, children: [Image.asset('lib/ui/images/splash.png')]),
      ),
    );
  }
}
