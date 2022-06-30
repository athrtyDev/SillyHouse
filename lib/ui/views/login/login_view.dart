import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/viewmodels/login_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/ui/widgets/my_text_field.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  FocusNode _focusNameInput = new FocusNode();
  FocusNode _focusPasswordInput = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNameInput.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          child: Scaffold(
              appBar: myAppBar(title: "Нэвтрэх", leadingFunction: () => Navigator.pop(context)) as PreferredSizeWidget?,
              backgroundColor: Colors.white,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Image.asset('lib/ui/images/login_background.png', fit: BoxFit.cover),
                  ),
                  Container(
                    color: AppColors.secondaryColor.withOpacity(0.3),
                    padding: EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 30),
                    child: Column(
                      children: [
                        // Text(
                        //   "Нэвтрэх",
                        //   style: GoogleFonts.kurale(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
                        // ),
                        // SizedBox(height: 20),
                        MyTextField(
                          controller: _nameInput,
                          keyboardType: TextInputType.text,
                          icon: Icons.person,
                          hintText: "Нэвтрэх нэр",
                          focusNode: _focusNameInput,
                          borderColor: AppColors.baseColor,
                        ),
                        MyTextField(
                          controller: _passwordInput,
                          keyboardType: TextInputType.number,
                          icon: Icons.security_rounded,
                          hintText: "Нууц үг",
                          focusNode: _focusPasswordInput,
                          borderColor: AppColors.baseColor,
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            _login(model);
                          },
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
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  _login(LoginModel model) async {
    if (_nameInput.text != '' && _passwordInput.text != '') {
      User? user = await model.login(_nameInput.text, _passwordInput.text);
      if (user != null) {
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, '/mainPage', arguments: null);
      } else {
        Flushbar(
          message: 'Нэр, нууц үг буруу байна.',
          padding: EdgeInsets.all(25),
          backgroundColor: Color(0xff36c1c8),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    } else {
      Flushbar(
        message: 'Мэдээллээ бүрэн оруулна уу.',
        padding: EdgeInsets.all(25),
        backgroundColor: Color(0xff36c1c8),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
