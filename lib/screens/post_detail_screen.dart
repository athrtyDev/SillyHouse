import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/bloc/user/user_cubit.dart';
import 'package:sillyhouseorg/core/classes/constant.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/utils/media_controller.dart';
import 'package:sillyhouseorg/utils/utils.dart';
import 'package:sillyhouseorg/widgets/back_button.dart';
import 'package:sillyhouseorg/widgets/button.dart';
import 'package:sillyhouseorg/widgets/my_media_player.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/profile_picture.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final bool? fromTappingComment;

  PostDetailScreen({required this.post, this.fromTappingComment = false});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostCubit cubit = PostCubit();
  FocusNode _focusComment = new FocusNode();
  TextEditingController _commentInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.getPostDetail(widget.post);
    if (widget.fromTappingComment != null && widget.fromTappingComment!) {
      Future.delayed(Duration(milliseconds: 200), () {
        FocusScope.of(context).requestFocus(_focusComment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is PostDetail) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop({'post': state.post});
              return false;
            },
            child: SafeArea(
              // top: false,
              child: Scaffold(
                  backgroundColor: Styles.backgroundColor,
                  // appBar: myAppBar(
                  //     title: state.post.activity!.name,
                  //     leadingFunction: () {
                  //       Navigator.of(context).pop({'post': state.post});
                  //       return true;
                  //     }),
                  body: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              ConstrainedBox(
                                constraints: new BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                                ),
                                child: Container(
                                  // height: 400,
                                  child: state.post.isSelfie != null && state.post.isSelfie!
                                      ? mediaController.getFlippedImage(MyMediaPlayer(
                                          url: state.post.mediaDownloadUrl!,
                                          type: state.post.uploadMediaType!,
                                          placeHolderUrl: state.post.coverDownloadUrl,
                                        ))
                                      : MyMediaPlayer(
                                          url: state.post.mediaDownloadUrl!,
                                          type: state.post.uploadMediaType!,
                                          placeHolderUrl: state.post.coverDownloadUrl,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop({'post': state.post});
                                  },
                                  child: MyBackButton(buttonColor: Styles.whiteColor),
                                ),
                              ),
                              Positioned(
                                right: 15,
                                top: 20,
                                child: _deletePostButton(),
                              ),
                            ],
                          ),
                          _comments(state.post),
                          // _likeCommentButton(state.post),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        } else
          return SizedBox();
      },
    );
  }

  Widget _comments(Post post) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        // borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          // USER INFO
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 45,
                child: ProfilePicture(url: post.userProfilePic),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText.large(post.userName!, textColor: Styles.textColor, fontWeight: Styles.wBold),
                  MyText.small(Utils.convertDate(post.postDate!), textColor: Styles.textColor70, fontWeight: Styles.wBold),
                ],
              ),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusComment);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset('lib/assets/comment.svg', color: Styles.textColor),
                          SizedBox(width: 8),
                          MyText.medium(
                            post.commentCount.toString(),
                            fontWeight: Styles.wBold,
                            textColor: Styles.textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.likePostDetailPost(post, context.read<UserCubit>().state.user!.id!);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/heart.svg',
                            color: post.isUserLiked ? Styles.baseColor3 : Styles.textColor,
                          ),
                          SizedBox(width: 8),
                          MyText.medium(
                            post.likeCount.toString(),
                            fontWeight: Styles.wBold,
                            textColor: post.isUserLiked ? Styles.baseColor3 : Styles.textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // INPUT
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentInput,
                  focusNode: _focusComment,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontWeight: Styles.wSemiBold,
                    fontSize: Styles.medium,
                    color: Styles.textColor,
                  ),
                  onSubmitted: (newComment) {
                    _addComment(post.postId!);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: new BorderSide(color: Styles.textColor10)),
                    focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Styles.textColor10)),
                    disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Styles.textColor10)),
                    enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Styles.textColor10)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    fillColor: Styles.whiteColor,
                    filled: true,
                    hintText: "Сэтгэгдэл бичих",
                    hintStyle: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: Styles.wNormal,
                      fontSize: Styles.medium,
                      color: Styles.textColor70,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Button.accent(
                text: "Бичих",
                padding: EdgeInsets.symmetric(horizontal: 18),
                onTap: () {
                  _addComment(post.postId!);
                },
              ),
            ],
          ),
          // LIST COMMENTS
          post.listComment == null || post.listComment!.isEmpty
              ? SizedBox(height: 10)
              : Column(
                  children: List.generate(post.listComment!.length, (index) {
                    return ListTile(
                      leading: Container(
                        height: 45,
                        width: 45,
                        child: ProfilePicture(url: post.listComment![index].userProfilePic),
                      ),
                      title: Row(
                        children: [
                          MyText.large(post.listComment![index].userName!,
                              textColor: post.listComment![index].userType == 'teacher' ? Styles.baseColor2 : Styles.textColor),
                          post.listComment![index].userType == 'teacher'
                              ? MyText.medium(' / Silly House багш', textColor: Styles.textColor70)
                              : SizedBox(),
                        ],
                      ),
                      subtitle: MyText.large(
                        post.listComment![index].comment!,
                        fontWeight: Styles.wNormal,
                      ),
                      trailing: context.read<UserCubit>().state.user!.id == post.listComment![index].userId ||
                              context.read<UserCubit>().state.user!.type == UserRole.admin
                          ? Builder(
                              builder: (context) => GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Container(
                                          height: 70,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: Icon(Icons.delete_forever, color: Styles.textColor),
                                                  title: Text('Устгах'),
                                                  onTap: () {
                                                    cubit.deleteComment(post.listComment![index].commentId!);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                //Divider(color: Colors.grey[300], height: 1, thickness: 2),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: 35,
                                  width: 40,
                                  color: Colors.transparent,
                                  child: Icon(Icons.more_vert, color: Styles.textColor70, size: 20),
                                ),
                              ),
                            )
                          : SizedBox(),
                      //trailing: Icon(Icons.menu, color: Colors.white),
                    );
                  }),
                ),
        ],
      ),
    );
  }

  _addComment(String postId) {
    if (_commentInput.text != "") {
      _focusComment.unfocus();
      cubit.addComment(_commentInput.text, context.read<UserCubit>().state.user!, postId);
      _commentInput.text = '';
    } else {
      _focusComment.unfocus();
    }
  }

  deletePost(Post post, BuildContext context) async {
    final Api _api = Api();
    await _api.deletePost(post);
    app.allPost!.remove(post);
  }

  _deletePostButton() {
    return context.read<UserCubit>().state.user!.type == "admin" ||
            widget.post.userId == context.read<UserCubit>().state.user!.id!
        ? InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return StatefulBuilder(builder: (BuildContext statefulContext, StateSetter setBottomSheetState) {
                      return Container(
                        height: 85,
                        color: Styles.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: Icon(Icons.delete_forever, color: Styles.textColor),
                            title: Text('Устгах'),
                            onTap: () {
                              Navigator.pop(context);
                              showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: MyText.large('Устгах уу?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: MyText('Үгүй'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: MyText('Тийм'),
                                        onPressed: () async {
                                          try {
                                            await deletePost(widget.post, context);
                                          } on Exception catch (_) {}
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              '/mainPage', (Route<dynamic> route) => false,
                                              arguments: {'tabIndex': 4});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
                  });
            },
            child: Container(
              height: 35,
              width: 40,
              color: Styles.textColor05,
              child: Icon(Icons.more_vert, color: Styles.whiteColor, size: 25),
            ),
          )
        : SizedBox();
  }
}
