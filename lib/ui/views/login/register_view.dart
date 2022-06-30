import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/viewmodels/login_model.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/ui/widgets/my_text_field.dart';
import 'package:sillyhouseorg/ui/widgets/profile_picture.dart';
import 'package:sillyhouseorg/ui/widgets/take_profile_picture_page.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _ageInput = TextEditingController();
  final TextEditingController _emailInput = TextEditingController();
  final ScrollController _controller = ScrollController();
  String gender = "";
  File? profileFile;

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          child: Scaffold(
              appBar: myAppBar(title: "Бүртгүүлэх", leadingFunction: () => Navigator.pop(context)) as PreferredSizeWidget?,
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
                    padding: EdgeInsets.only(right: 30, left: 30, top: 30),
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: <Widget>[
                          _profilePicture(),
                          MyTextField(
                            controller: _emailInput,
                            keyboardType: TextInputType.emailAddress,
                            icon: Icons.email,
                            hintText: "Эцэг, эхийн и-мэйл",
                          ),
                          MyTextField(
                            controller: _nameInput,
                            keyboardType: TextInputType.text,
                            icon: Icons.person,
                            hintText: "Хүүхдийн нэвтрэх нэр",
                          ),
                          MyTextField(
                            controller: _ageInput,
                            keyboardType: TextInputType.number,
                            icon: Icons.calendar_today_rounded,
                            hintText: "Хүүхдийн нас",
                          ),
                          sexSelector(),
                          MyTextField(
                            controller: _passwordInput,
                            keyboardType: TextInputType.number,
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
                              child: model.state == ViewState.Busy
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.baseColor,
                                        elevation: 4.0,
                                      ),
                                      child: Text('БҮРТГҮҮЛЭХ', style: GoogleFonts.kurale()),
                                      onPressed: () => _register(model),
                                    )),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  _profilePicture() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Container(
        width: 130,
        height: 130,
        child: ProfilePicture(file: profileFile, onTap: () => _addPicture()),
      ),
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
                  border: Border.all(color: gender == 'male' ? AppColors.baseColor : Colors.transparent),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.male, color: gender == 'male' ? Colors.black : Colors.grey[400]),
                    SizedBox(width: 8),
                    Text(
                      "Эрэгтэй",
                      style: GoogleFonts.kurale(color: gender == 'male' ? Colors.black : Colors.grey[400], fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 30),
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
                  border: Border.all(color: gender == 'female' ? AppColors.baseColor : Colors.transparent),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.female, color: gender == 'female' ? Colors.black : Colors.grey[400]),
                    SizedBox(width: 8),
                    Text(
                      "Эмэгтэй",
                      style: GoogleFonts.kurale(color: gender == 'female' ? Colors.black : Colors.grey[400], fontSize: 16),
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

  _register(LoginModel model) async {
    if (_nameInput.text != '' && _passwordInput.text != '' && _ageInput.text != '' && _emailInput.text != '' && gender != ""
        //&& profileFile != null
        ) {
      bool isSuccess =
          await model.registerUser(_nameInput.text, _passwordInput.text, _ageInput.text, _emailInput.text, gender, profileFile);
      if (isSuccess)
        Navigator.pushNamed(context, '/mainPage', arguments: null);
      else {
        // Register fail. Username exists
        Flushbar(
          message: 'Нэр бүртгэлтэй байна. Өөр нэр сонгоно уу.',
          padding: EdgeInsets.all(25),
          backgroundColor: Color(0xff36c1c8),
          duration: Duration(seconds: 3),
        ).show(context);
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

  _addPicture() async {
    PickedMedia? media = await Navigator.push(context, MaterialPageRoute(builder: (context) => TakeProfilePicturePage()));
    if (media != null)
      setState(() {
        profileFile = media.storageFile;
      });
  }
}
