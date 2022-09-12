import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/my_text_field.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return BlocListener<UserCubit, UserState>(
      bloc: context.read<UserCubit>(),
      listener: _blocListener,
      child: _mainScreen(),
    );
  }

  void _blocListener(BuildContext context, UserState state) {
    if (state.user == null) {
      Flushbar(
        message: 'Нэр, нууц үг буруу байна.',
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, '/mainPage');
    }
  }

  Widget _mainScreen() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
          appBar: myAppBar(title: "Нэвтрэх", leadingFunction: () => Navigator.pop(context)),
          backgroundColor: Styles.whiteColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Opacity(
              //   opacity: 0.4,
              //   child: Image.asset('lib/assets/login_background.png', fit: BoxFit.cover),
              // ),
              Container(
                // color: Styles.secondaryColor.withOpacity(0.3),
                padding: EdgeInsets.only(left: 30, right: 30, top: 70, bottom: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SvgPicture.asset('lib/assets/home_header.svg', height: 40),
                      SizedBox(height: 40),
                      MyTextField(
                        controller: _nameInput,
                        keyboardType: TextInputType.text,
                        icon: Icons.person,
                        hintText: "Нэвтрэх нэр",
                        focusNode: _focusNameInput,
                        // borderColor: Styles.baseColor2,
                      ),
                      MyTextField(
                        controller: _passwordInput,
                        keyboardType: TextInputType.number,
                        icon: Icons.security_rounded,
                        hintText: "Нууц үг",
                        focusNode: _focusPasswordInput,
                        // borderColor: Styles.baseColor2,
                      ),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          _login();
                        },
                        child: Container(
                          width: 230,
                          height: 50,
                          alignment: Alignment(0, 0),
                          decoration: BoxDecoration(
                            color: Styles.baseColor2,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: MyText('Нэвтрэх', textColor: Styles.whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _login() async {
    if (_nameInput.text != '' && _passwordInput.text != '') {
      context.read<UserCubit>().login(_nameInput.text, _passwordInput.text);
    } else {
      Flushbar(
        message: 'Мэдээллээ бүрэн оруулна уу.',
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
