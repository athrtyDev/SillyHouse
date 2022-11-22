import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/my_text_field.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/take_profile_picture_page.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _ageInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final ScrollController _controller = ScrollController();
  String gender = "";
  File? profileFile;
  bool isSelfie = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Scaffold(
            appBar: myAppBar(title: "Бүртгүүлэх", leadingFunction: () => Navigator.pop(context)),
            backgroundColor: Styles.whiteColor,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Opacity(
                //   opacity: 0.4,
                //   child: Image.asset('lib/assets/login_background.png', fit: BoxFit.cover),
                // ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    // color: Styles.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _profilePicture(),
                        MyText("Эцэг, эхийн и-мэйл"),
                        SizedBox(height: 5),
                        MyTextField(
                          controller: _emailInput,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email,
                          hintText: "Эцэг, эхийн и-мэйл",
                        ),
                        MyText("Нэвтрэх нэр"),
                        SizedBox(height: 5),
                        MyTextField(
                          controller: _nameInput,
                          keyboardType: TextInputType.text,
                          icon: Icons.person,
                          hintText: "Хүүхдийн нэвтрэх нэр",
                        ),
                        Row(
                          children: [
                            MyText("Нас"),
                            MyText(" /заавал биш/", textColor: Styles.textColor70),
                          ],
                        ),
                        SizedBox(height: 5),
                        MyTextField(
                          controller: _ageInput,
                          keyboardType: TextInputType.number,
                          icon: Icons.calendar_today_rounded,
                          hintText: "Хүүхдийн нас",
                        ),
                        Row(
                          children: [
                            MyText("Хүйс"),
                            MyText(" /заавал биш/", textColor: Styles.textColor70),
                          ],
                        ),
                        SizedBox(height: 5),
                        sexSelector(),
                        MyText("Нууц үг"),
                        SizedBox(height: 5),
                        MyTextField(
                          controller: _passwordInput,
                          icon: Icons.security_rounded,
                          hintText: "Нууц үг",
                          isPassword: true,
                          onTap: () {
                            _scrollDown();
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Styles.baseColor2,
                                elevation: 4.0,
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator()
                                  : MyText(
                                      'Бүртгүүлэх',
                                      textColor: Styles.whiteColor,
                                    ),
                              onPressed: () => _register(),
                            )),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  _profilePicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Container(
            width: 80,
            height: 80,
            child: ProfilePicture(file: profileFile, onTap: () => _addPicture(), isSelfie: isSelfie),
          ),
        ),
      ],
    );
  }

  Widget sexSelector() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = "male";
                  _scrollDown();
                });
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: gender == 'male' ? Styles.baseColor2 : Colors.transparent),
                  color: Styles.textColor10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.male, color: gender == 'male' ? Styles.textColor : Styles.textColor50),
                    SizedBox(width: 8),
                    MyText.medium(
                      "Эрэгтэй",
                      textColor: gender == 'male' ? Styles.textColor : Styles.textColor50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = "female";
                  _scrollDown();
                });
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: gender == 'female' ? Styles.baseColor2 : Colors.transparent),
                  color: Styles.textColor10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.female, color: gender == 'female' ? Styles.textColor : Styles.textColor50),
                    SizedBox(width: 8),
                    MyText.medium(
                      "Эмэгтэй",
                      textColor: gender == 'female' ? Styles.textColor : Styles.textColor50,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _register() async {
    if (isLoading) return;
    if (_nameInput.text == '' || _passwordInput.text == '' || _emailInput.text == '') {
      Flushbar(
        message: 'Мэдээллээ бүрэн оруулна уу.',
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
    } else if (profileFile == null) {
      Flushbar(
        message: 'Зургаа оруулна уу',
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        isLoading = true;
      });
      bool isSuccess = await context.read<UserCubit>().register(
            _nameInput.text,
            _passwordInput.text,
            _ageInput.text,
            _emailInput.text,
            gender,
            profileFile,
          );
      setState(() {
        isLoading = false;
      });
      if (isSuccess) {
        Navigator.pushNamed(context, '/mainPage');
      } else {
        // Register fail. Username exists
        Flushbar(
          message: 'Нэр бүртгэлтэй байна. Өөр нэр сонгоно уу.',
          padding: EdgeInsets.all(25),
          backgroundColor: Styles.baseColor1,
          duration: Duration(seconds: 3),
        ).show(context);
      }
    }
  }

  _addPicture() async {
    MyMediaObject? media = await Navigator.push(context, MaterialPageRoute(builder: (context) => TakeProfilePicturePage()));
    if (media != null)
      setState(() {
        isSelfie = media.isSelfie != null && media.isSelfie!;
        profileFile = media.storageFile;
        print("aaaaa $isSelfie");
      });
  }
}
