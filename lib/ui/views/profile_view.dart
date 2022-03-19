import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/core/services/authentication_service.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:sillyhouseorg/core/viewmodels/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sillyhouseorg/ui/widgets/gallery_post_widget.dart';
import 'package:sillyhouseorg/ui/widgets/profile_picture.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
      onModelReady: (model) => model.loadPostsByUser(context),
      builder: (context, model, child) => model.state == ViewState.Busy
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  children: [
                    _profileHeader(model.loggedUser),
                    Expanded(
                      child: model.listUserAllPosts == null
                          ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350))
                          : GridView.count(
                              controller: scrollViewController,
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              childAspectRatio: 0.75,
                              scrollDirection: Axis.vertical,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 8,
                              children: model.listUserAllPosts.map((Post post) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pushNamed(context, '/post_detail', arguments: post);
                                      });
                                    },
                                    child: GalleryPostWidget(post: post));
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _profileHeader(User loggedUser) {
    return Container(
      height: 185,
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.whiteColor),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: ProfilePicture(url: loggedUser.profile_pic),
                ),
                SizedBox(width: 15),
                Text('Сайн уу, ' + loggedUser.name, style: GoogleFonts.kurale(fontSize: 18, color: Colors.black)),
              ],
            ),
            GestureDetector(
              child: Container(
                height: 40,
                width: 50,
                color: Colors.transparent,
                child: Icon(
                  Icons.menu,
                  color: AppColors.baseColor,
                  size: 30,
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        height: 90,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.exit_to_app, color: Colors.black),
                                title: Text('Гарах', style: GoogleFonts.kurale(fontSize: 18, color: Colors.black)),
                                onTap: () async {
                                  app.logOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil('/greeting', (Route<dynamic> route) => false);
                                },
                              ),
                              //Divider(color: Colors.grey[300], height: 1, thickness: 2),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Бүтээлүүд', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
                Text(loggedUser.postTotal.toString(),
                    style: GoogleFonts.kurale(color: AppColors.baseColor, fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
            Column(
              children: [
                Text('Ур чадвар', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
                Text('+' + loggedUser.skillTotal.toString(),
                    style: GoogleFonts.kurale(color: AppColors.baseColor, fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
            Column(
              children: [
                Text('Like', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
                Text(loggedUser.likeTotal.toString(),
                    style: GoogleFonts.kurale(color: AppColors.baseColor, fontWeight: FontWeight.bold, fontSize: 24)),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
