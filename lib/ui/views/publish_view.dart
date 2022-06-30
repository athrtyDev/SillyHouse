import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'package:sillyhouseorg/core/classes/post.dart';
import 'package:sillyhouseorg/ui/widgets/my_app_bar.dart';
import 'package:sillyhouseorg/ui/widgets/take_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:sillyhouseorg/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:sillyhouseorg/core/viewmodels/publish_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class PublishView extends StatefulWidget {
  final Post? post;
  PublishView({required this.post});

  @override
  _PublishViewState createState() => _PublishViewState();
}

class _PublishViewState extends State<PublishView> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return BaseView<PublishModel>(
      builder: (context, model, child) => isLoading
          ? SizedBox()
          : SafeArea(
              top: false,
              child: WillPopScope(
                onWillPop: () async {
                  // Prevent back navigation when uploading
                  if (model.state == ViewState.Idle) {
                    // Pause video before navigation
                    if (videoController != null && videoController!.value.isPlaying) {
                      videoController!.pause();
                    }
                    if (widget.post!.pickedMedia != null && widget.post!.pickedMedia!.storageFile != null) {
                      await widget.post!.pickedMedia!.storageFile!.delete();
                    }
                    if (widget.post!.pickedMedia != null && widget.post!.pickedMedia!.path != null) {
                      await File(widget.post!.pickedMedia!.path!).delete();
                    }
                    return new Future.value(true);
                  } else {
                    return new Future.value(false);
                  }
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: myAppBar(title: "Бүтээл оруулах", leadingFunction: () => Navigator.pop(context)) as PreferredSizeWidget?,
                  body: widget.post!.pickedMedia == null
                      ? Center(
                          child: GestureDetector(
                          onTap: () => _showCamera(),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 450,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.asset('lib/ui/images/no_image.png'),
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
                                    height: (widget.post!.pickedMedia!.type == 'video' &&
                                            videoController != null &&
                                            videoController!.value.size != null)
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
                                        widget.post!.pickedMedia!.storageFile == null
                                            ? Image.file(File(widget.post!.pickedMedia!.path!), fit: BoxFit.fitWidth)
                                            : Image.file(File(widget.post!.pickedMedia!.storageFile!.path), fit: BoxFit.fitWidth)),
                              ],
                            )),
                          ),
                          // ACTION BUTTONS
                          Positioned(
                              bottom: 30,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: model.state == ViewState.Busy
                                    ? Center(
                                        child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 10),
                                          Text("Бүтээлийг нь хуулж байна... Одоохон дууслаа.",
                                              style: GoogleFonts.kurale(fontSize: 14, color: Color(0xff36c1c8))),
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
                                                widget.post!.pickedMedia!.storageFile!.delete();
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
                                              try {
                                                widget.post!.uploadMediaType = widget.post!.pickedMedia!.type;
                                                model.uploadFile(
                                                    widget.post!,
                                                    widget.post!.pickedMedia!.storageFile == null
                                                        ? File(widget.post!.pickedMedia!.path!)
                                                        : File(widget.post!.pickedMedia!.storageFile!.path));
                                              } on Exception catch (e) {
                                                print('error uploading media: ' + e.toString());
                                              }
                                              Navigator.of(context).pushNamedAndRemoveUntil(
                                                  '/mainPage', (Route<dynamic> route) => false,
                                                  arguments: true);
                                            },
                                          ),
                                        ],
                                      ),
                              )),
                        ]),
                ),
              ),
            ),
    );
  }

  void _showCamera() async {
    final cameras = await availableCameras();
    if (cameras == null || cameras.length == 0) return;
    widget.post!.cameras = cameras;
    PickedMedia? media =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePicturePage(post: widget.post)));
    _updateMedia(media);
  }

  void _updateMedia(PickedMedia? media) async {
    setState(() {
      isLoading = true;
    });
    widget.post!.pickedMedia = media;

    if (widget.post!.pickedMedia != null && widget.post!.pickedMedia!.type == 'video') {
      if (widget.post!.pickedMedia!.storageFile == null)
        videoController = VideoPlayerController.file(File(widget.post!.pickedMedia!.path!));
      else
        videoController = VideoPlayerController.file(File(widget.post!.pickedMedia!.storageFile!.path));
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
