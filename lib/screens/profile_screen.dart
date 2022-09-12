import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/cubit.dart';
import 'package:sillyhouseorg/core/classes/constant.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PostCubit cubit = PostCubit();
  ScrollController? scrollViewController;

  @override
  void initState() {
    super.initState();
    cubit.getPostsByUser(context.read<UserCubit>().state.user!.id!);
    scrollViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Styles.backgroundColor,
        child: Column(
          children: [
            _profileHeader(),
            Expanded(
              child: BlocBuilder<PostCubit, PostState>(
                bloc: cubit,
                builder: (context, state) {
                  if (state is ProfileLoaded && state.listPosts != null && state.listPosts!.isNotEmpty) {
                    return GridView.count(
                      controller: scrollViewController,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: 0.8,
                      scrollDirection: Axis.vertical,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                      children: state.listPosts!.map((Post post) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/post_detail', arguments: {'post': post});
                          },
                          child: CachedNetworkImage(
                            imageUrl: post.coverDownloadUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (state is PostLoading) {
                    return SizedBox();
                  } else
                    return Center(child: Image.asset('lib/assets/no_post.png', height: 350));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _profileHeader() {
    User user = context.read<UserCubit>().state.user!;
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Styles.whiteColor),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: ProfilePicture(url: user.profile_pic),
                ),
                SizedBox(width: 15),
                MyText.xlarge('Сайн уу, ' + user.name!, textColor: Styles.textColor, fontWeight: Styles.wSemiBold),
              ],
            ),
            InkWell(
              child: Container(
                height: 40,
                width: 50,
                color: Colors.transparent,
                child: Icon(
                  Icons.menu,
                  color: Styles.textColor70,
                  size: 30,
                ),
              ),
              onTap: () {
                _showUserMenu();
              },
            ),
          ],
        ),
        SizedBox(height: 15),
        BlocBuilder<PostCubit, PostState>(
          bloc: cubit,
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      MyText.large('Бүтээлүүд', fontWeight: Styles.wSemiBold),
                      MyText(
                        state.postTotal.toString(),
                        textColor: Styles.baseColor5,
                        fontWeight: Styles.wSemiBold,
                        size: 24,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      MyText.large('Ур чадвар', fontWeight: Styles.wSemiBold),
                      MyText(
                        '+' + state.skillTotal.toString(),
                        textColor: Styles.baseColor5,
                        fontWeight: Styles.wSemiBold,
                        size: 24,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      MyText('Like', fontWeight: Styles.wSemiBold),
                      MyText(
                        state.likeTotal.toString(),
                        textColor: Styles.baseColor5,
                        fontWeight: Styles.wSemiBold,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              );
            } else
              return SizedBox();
          },
        ),
      ]),
    );
  }

  _showUserMenu() {
    User user = context.read<UserCubit>().state.user!;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.type != null && user.type == UserRole.admin)
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings_outlined, color: Styles.textColor),
                      title: MyText.large('Админ'),
                      onTap: () async {
                        Navigator.pushNamed(context, '/admin');
                      },
                    ),
                  if (user.type != null && user.type == UserRole.admin) Divider(color: Colors.grey[300], height: 1, thickness: 2),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Styles.textColor),
                    title: MyText.large('Гарах'),
                    onTap: () async {
                      context.read<UserCubit>().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil('/greeting', (Route<dynamic> route) => false);
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
  }
}
