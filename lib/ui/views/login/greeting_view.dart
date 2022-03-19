import 'package:sillyhouseorg/core/viewmodels/login_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GreetingView extends StatefulWidget {
  @override
  _GreetingViewState createState() => _GreetingViewState();
}

class _GreetingViewState extends State<GreetingView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        builder: (context, model, child) => SafeArea(
              top: false,
              child: Scaffold(
                  backgroundColor: AppColors.whiteColor,
                  body: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Image.asset('lib/ui/images/login_background.png', fit: BoxFit.cover),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.3),
                        child: Column(
                          children: [
                            _headerText(),
                            Expanded(child: SizedBox()),
                            _loginButtons(model),
                          ],
                        ),
                      ),
                    ],
                  )),
            ));
  }

  _headerText() {
    return Container(
      height: 300,
      alignment: Alignment(0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Silly House",
            style: GoogleFonts.kurale(
              color: AppColors.baseColor,
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Бүтээлч хүүхдүүдийн нэгдэл",
            style: GoogleFonts.kurale(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  _loginButtons(model) {
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
                color: AppColors.baseColor,
                border: Border.all(color: AppColors.baseColor),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text('НЭВТРЭХ', style: GoogleFonts.kurale(letterSpacing: 1, color: Colors.white)),
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
                color: AppColors.whiteColor,
                border: Border.all(color: AppColors.baseColor),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text('БҮРТГҮҮЛЭХ',
                  style: GoogleFonts.kurale(
                    letterSpacing: 1,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
