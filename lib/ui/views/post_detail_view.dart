import 'package:sillyhouseorg/core/classes/comment.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/core/classes/user.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/viewmodels/activity_instruction_model.dart';
import 'package:sillyhouseorg/locator.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sillyhouseorg/ui/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/ui/widgets/my_media.dart';
import 'package:uuid/uuid.dart';

class PostDetailView extends StatefulWidget {
  final Post? post;

  PostDetailView({required this.post});

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final TextEditingController _commentInput = TextEditingController();
  FocusNode _focusCommentInput = new FocusNode();
  ViewState? state;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityInstructionModel>(
      builder: (context, model, child) => SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: myAppBar(title: widget.post!.activity!.name, leadingFunction: () => Navigator.pop(context)) as PreferredSizeWidget?,
          body: Container(
            child: state == ViewState.Busy
                ? Container(child: Center(child: CircularProgressIndicator()))
                : InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                        MyMedia(url: widget.post!.mediaDownloadUrl, type: widget.post!.uploadMediaType),
                        _likeAndComment(),
                        Divider(thickness: 0.3, color: Colors.grey[200], height: 0),
                        // LIST COMMENTS
                        widget.post!.listComment == null || widget.post!.listComment!.isEmpty
                            ? Container()
                            : Column(
                                children: List.generate(widget.post!.listComment!.length, (index) {
                                  return ListTile(
                                    leading: Icon(Icons.account_circle, color: AppColors.textColor, size: 34),
                                    title: Row(
                                      children: [
                                        widget.post!.listComment![index].userType == 'teacher'
                                            ? Icon(Icons.school, color: Colors.orange, size: 18)
                                            : Text(''),
                                        widget.post!.listComment![index].userType == 'teacher' ? SizedBox(width: 5) : Text(''),
                                        Text(
                                            widget.post!.listComment![index].userName! +
                                                (widget.post!.listComment![index].userType == 'teacher'
                                                    ? ' [Silly House-н багш]'
                                                    : ''),
                                            style: GoogleFonts.kurale(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: widget.post!.listComment![index].userType == 'teacher'
                                                    ? Colors.orange
                                                    : AppColors.textColor)),
                                      ],
                                    ),
                                    subtitle: Text(widget.post!.listComment![index].comment!,
                                        style: GoogleFonts.kurale(fontSize: 13, color: AppColors.textColor)),
                                    trailing: Provider.of<User>(context, listen: false).id !=
                                            widget.post!.listComment![index].userId
                                        ? Text('')
                                        : Builder(
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
                                                                leading: Icon(Icons.delete_forever, color: AppColors.textColor),
                                                                title: Text('Устгах',
                                                                    style: GoogleFonts.kurale(
                                                                        fontSize: 18, color: AppColors.textColor)),
                                                                onTap: () {
                                                                  deleteComment(widget.post!.listComment![index]);
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
                                                child: Icon(Icons.more_vert, color: Colors.white, size: 25),
                                              ),
                                            ),
                                          ),
                                    //trailing: Icon(Icons.menu, color: Colors.white),
                                  );
                                }),
                              ),
                        // ADD COMMENT TEXTFIELD
                        Container(
                          child: TextField(
                            controller: _commentInput,
                            focusNode: _focusCommentInput,
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.kurale(color: Colors.black),
                            onSubmitted: (newComment) {
                              _focusCommentInput.unfocus();
                              _commentInput.text = '';
                              postComment(newComment);
                              getPostComments();
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.grey[100]!)),
                                disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                isDense: true,
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: _focusCommentInput.hasFocus ? "Сэтгэгдэл бичих" : "",
                                hintStyle:
                                    GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 15.0)),
                          ),
                        )
                        // Bottom navigation
                      ]),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // _deletePostButton() {
  //   return widget.post.userId != Provider.of<User>(context, listen: false).id
  //       ? SizedBox()
  //       : InkWell(
  //           onTap: () {
  //             if (videoController != null && videoController.value.isPlaying) {
  //               videoController.pause();
  //             }
  //             setState(() {});
  //             showModalBottomSheet(
  //                 context: context,
  //                 builder: (BuildContext bc) {
  //                   return Container(
  //                     height: 80,
  //                     color: AppColors.mainTextColor,
  //                     child: Padding(
  //                       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //                       child: Column(
  //                         children: [
  //                           ListTile(
  //                             leading: Icon(Icons.delete_forever, color: AppColors.mainTextColor),
  //                             title: Text('Устгах', style: GoogleFonts.kurale(fontSize: 18, color: AppColors.mainTextColor)),
  //                             onTap: () {
  //                               Navigator.pop(context);
  //                               showCupertinoDialog(
  //                                 context: context,
  //                                 barrierDismissible: true,
  //                                 builder: (context) {
  //                                   return CupertinoAlertDialog(
  //                                     title: Text('Устгах уу?',
  //                                         style: GoogleFonts.kurale(fontSize: 18, color: AppColors.mainTextColor)),
  //                                     actions: [
  //                                       CupertinoDialogAction(
  //                                         child: Text('Үгүй',
  //                                             style: GoogleFonts.kurale(fontSize: 18, color: AppColors.mainTextColor)),
  //                                         onPressed: () {
  //                                           Navigator.pop(context);
  //                                         },
  //                                       ),
  //                                       CupertinoDialogAction(
  //                                         child: Text('Тийм',
  //                                             style: GoogleFonts.kurale(fontSize: 18, color: AppColors.mainTextColor)),
  //                                         onPressed: () {
  //                                           deletePost(widget.post, context);
  //                                         },
  //                                       ),
  //                                     ],
  //                                   );
  //                                 },
  //                               );
  //                             },
  //                           ),
  //                           //Divider(color: Colors.grey[300], height: 1, thickness: 2),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 });
  //           },
  //           child: Container(
  //             height: 35,
  //             width: 40,
  //             color: Colors.transparent,
  //             child: Icon(Icons.more_vert, color: AppColors.mainTextColor, size: 25),
  //           ),
  //         );
  // }

  _likeAndComment() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        //borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LIKE
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 3),
              height: 40,
              decoration: BoxDecoration(
                  //border: Border.all(color: AppColors.secondaryColor),
                  //borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _focusCommentInput.unfocus();
                    if (widget.post!.isUserLiked) {
                      widget.post!.dislikePost(widget.post!, Provider.of<User>(context, listen: false).id);
                    } else {
                      widget.post!.likePost(widget.post!, Provider.of<User>(context, listen: false).id);
                    }
                  });
                },
                child: Container(
                  height: 40,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.post!.isUserLiked
                          ? Image.asset('lib/ui/images/icon_love_liked.png', height: 16)
                          : Image.asset('lib/ui/images/icon_love.png', height: 10),
                      SizedBox(width: 5),
                      Text(widget.post!.likeCount == null ? '0' : widget.post!.likeCount.toString(),
                          style: GoogleFonts.kurale(color: AppColors.textColor, fontSize: 19)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // COMMENT
          Expanded(
            child: Container(
              height: 40,
              margin: EdgeInsets.only(top: 3, left: 3),
              width: MediaQuery.of(context).size.width / 2 - 0.5,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusCommentInput);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mode_comment_outlined, size: 16, color: AppColors.textColor),
                      SizedBox(width: 5),
                      Text('Сэтгэгдэл', style: GoogleFonts.kurale(color: AppColors.textColor, fontSize: 16)),
                      SizedBox(width: 5),
                      Text(
                          (widget.post!.listComment == null || widget.post!.listComment!.isEmpty)
                              ? '0'
                              : widget.post!.listComment!.length.toString(),
                          style: GoogleFonts.kurale(color: AppColors.textColor, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getPostComments() async {
    final Api _api = locator<Api>();
    widget.post!.listComment = await _api.getListComment(widget.post!.postId);
    setState(() {});
  }

  Future<void> postComment(String commentMessage) async {
    final Api _api = locator<Api>();
    User user = Provider.of<User>(context, listen: false);
    Comment comment = new Comment();
    comment.commentId = Uuid().v4();
    comment.postId = widget.post!.postId;
    comment.userId = user.id;
    comment.userName = user.name;
    comment.userProfilePic = user.profile_pic;
    comment.userType = user.type;
    comment.comment = commentMessage;
    comment.date = DateTime.now();
    await _api.postComment(comment);
    if (widget.post!.listComment == null) widget.post!.listComment = [];
    widget.post!.listComment!.add(comment);
    setState(() {});
  }

  void deletePost(Post post, BuildContext context) async {
    setState(() {
      state = ViewState.Busy;
    });
    final Api _api = locator<Api>();
    await _api.deletePost(post);
    setState(() {
      state = ViewState.Idle;
    });
    Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
  }

  void deleteComment(Comment deleteComment) async {
    setState(() {
      state = ViewState.Busy;
    });
    final Api _api = locator<Api>();
    await _api.deleteComment(deleteComment.commentId);
    if (widget.post!.listComment != null) {
      widget.post!.listComment!.removeWhere((item) => item.commentId == deleteComment.commentId);
    }
    setState(() {
      state = ViewState.Idle;
    });
  }
}
