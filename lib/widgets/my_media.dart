import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyMedia extends StatefulWidget {
  final String url;
  final String type;
  final String? placeHolderUrl;

  const MyMedia({required this.url, required this.type, this.placeHolderUrl});

  @override
  State<MyMedia> createState() => _MyMediaState();
}

class _MyMediaState extends State<MyMedia> {
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;
  bool isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    if (videoController != null) videoController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == 'image'
        ? CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: widget.url,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : isVideoLoading
            ? _videoPlaceHolder()
            : _videoPlayer();
  }

  Widget _videoPlayer() {
    return Container(
      height: getVideoHeight(),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
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
            videoController == null || videoController!.value.isPlaying
                ? SizedBox()
                : Center(child: Icon(Icons.play_circle_filled, color: Colors.white, size: 60)),
          ],
        ),
      ),
    );
  }

  Widget _videoPlaceHolder() {
    return Center(
      child: Stack(
        alignment: Alignment(0, 0),
        children: [
          widget.placeHolderUrl == null
              ? Container(
                  color: Colors.grey[100],
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                )
              : CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: widget.placeHolderUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  double getVideoHeight() {
    return (MediaQuery.of(context).size.width * videoController!.value.size.height) / videoController!.value.size.width;
  }

  void initVideo() async {
    try {
      if (widget.type == 'video') {
        videoController = VideoPlayerController.network(widget.url);
        await videoController!.initialize();
        videoController!.setLooping(false);
        videoController!.setVolume(4.0);
        videoController!.play();
        setState(() {
          isVideoLoading = false;
        });
      }
    } catch (ex) {
      print('error on loadPostVideo: ' + ex.toString());
    }
  }
}
