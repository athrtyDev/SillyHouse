import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sillyhouseorg/bloc/post/cubit.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/utils/media_controller.dart';
import 'package:sillyhouseorg/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/widgets/styles.dart';
import 'package:sillyhouseorg/widgets/take_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class PublishScreen extends StatefulWidget {
  final Post? post;
  PublishScreen({required this.post});

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> with SingleTickerProviderStateMixin {
  PostCubit cubit = PostCubit();
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.post!.pickedMedia == null)
      _showCamera();
    else
      _updateMedia(widget.post!.pickedMedia);
  }

  @override
  void dispose() {
    if (videoController != null) {
      videoController!.dispose();
    }
    //pickedMedia = null;
    super.dispose();
  }

  void _listener(BuildContext context, PostState state) {
    if (state is PostUploadSuccess) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false, arguments: {'uploadSuccess': true});
    }
    if (state is PostErrorState) {
      Flushbar(
        message: state.errorMessage,
        padding: EdgeInsets.all(25),
        backgroundColor: Styles.baseColor1,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox()
        : BlocListener<PostCubit, PostState>(
            bloc: cubit,
            listener: _listener,
            child: BlocBuilder<PostCubit, PostState>(
              bloc: cubit,
              builder: (context, state) {
                return SafeArea(
                  top: false,
                  child: WillPopScope(
                    onWillPop: () async {
                      // Prevent back navigation when uploading
                      if (state is PostInitState) {
                        // Pause video before navigation
                        if (videoController != null && videoController!.value.isPlaying) {
                          videoController!.pause();
                        }
                        return new Future.value(true);
                      } else {
                        // page is loading. Cannot back
                        return new Future.value(false);
                      }
                    },
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: myAppBar(title: "Бүтээл оруулах", leadingFunction: () => Navigator.pop(context)),
                      body: widget.post!.pickedMedia == null
                          ? Center(
                              child: GestureDetector(
                              onTap: () => _showCamera(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 450,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset('lib/assets/no_image.png'),
                                ),
                              ),
                            ))
                          : Stack(children: <Widget>[
                              // Media
                              Center(
                                child: SingleChildScrollView(
                                    child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: (widget.post!.pickedMedia!.type == 'video' && videoController != null)
                                          ? ((MediaQuery.of(context).size.width * videoController!.value.size.height) /
                                              videoController!.value.size.width)
                                          : null,
                                      width: widget.post!.pickedMedia!.type == 'video' ? MediaQuery.of(context).size.width : null,
                                      child: widget.post!.pickedMedia!.type == 'video' && videoController != null
                                          ?
                                          // Video
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (videoController!.value.isPlaying)
                                                    videoController!.pause();
                                                  else
                                                    videoController!.play();
                                                });
                                              },
                                              child: Stack(
                                                children: [
                                                  VideoPlayer(videoController!),
                                                  // Play button
                                                  videoController == null || videoController!.value.isPlaying
                                                      ? Text('')
                                                      : Center(
                                                          child: Icon(
                                                          Icons.play_circle_filled,
                                                          color: Colors.white,
                                                          size: 60,
                                                        )),
                                                ],
                                              ),
                                            )
                                          :
                                          // Image
                                          widget.post!.pickedMedia!.isSelfie != null && widget.post!.pickedMedia!.isSelfie!
                                              ? mediaController.getFlippedImage(
                                                  Image.file(widget.post!.pickedMedia!.storageFile, fit: BoxFit.fitWidth))
                                              : Image.file(widget.post!.pickedMedia!.storageFile, fit: BoxFit.fitWidth),
                                    ),
                                  ],
                                )),
                              ),
                              // ACTION BUTTONS
                              Positioned(
                                  bottom: 30,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: state is PostLoading
                                        ? Center(
                                            child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(width: 10),
                                              Text("Бүтээлийг нь хуулж байна... Одоохон дууслаа.",
                                                  style: GoogleFonts.kurale(fontSize: 14, color: Styles.baseColor1)),
                                            ],
                                          ))
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                child: Icon(Icons.close, size: 60, color: Colors.red),
                                                onTap: () async {
                                                  // if (widget.post.pickedMedia != null && widget.post.pickedMedia.storageFile != null) {
                                                  //   await widget.post.pickedMedia.storageFile.delete();
                                                  // }
                                                  // if (widget.post.pickedMedia != null && widget.post.pickedMedia.path != null) {
                                                  //   await File(widget.post.pickedMedia.path).delete();
                                                  // }
                                                  try {
                                                    widget.post!.pickedMedia!.storageFile.delete();
                                                  } on Exception catch (e) {
                                                    print('error deleting file: ' + e.toString());
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(width: 100),
                                              GestureDetector(
                                                child: Icon(Icons.check, size: 60, color: Colors.green),
                                                onTap: () {
                                                  if (videoController != null && videoController!.value.isPlaying) {
                                                    videoController!.pause();
                                                  }
                                                  cubit.uploadPost(widget.post!, widget.post!.pickedMedia!.storageFile);
                                                },
                                              ),
                                            ],
                                          ),
                                  )),
                            ]),
                    ),
                  ),
                );
              },
            ),
          );
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    if (cameras.length == 0) return;
    widget.post!.cameras = cameras;
    MyMediaObject? media =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePicturePage(post: widget.post)));
    _updateMedia(media);
  }

  void _updateMedia(MyMediaObject? media) async {
    setState(() {
      isLoading = true;
    });
    widget.post!.pickedMedia = media;

    if (widget.post!.pickedMedia != null && widget.post!.pickedMedia!.type == 'video') {
      if (widget.post!.pickedMedia!.storageFile == null)
        videoController = VideoPlayerController.file(File(widget.post!.pickedMedia!.path));
      else
        videoController = VideoPlayerController.file(File(widget.post!.pickedMedia!.storageFile.path));
      //initializeVideoPlayer = videoController.initialize();
      await videoController!.initialize();
      setState(() {
        videoController!.setLooping(true);
        videoController!.setVolume(4.0);
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
