import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:sillyhouseorg/widgets/loader.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class MyMediaPlayer extends StatefulWidget {
  final String url;
  final String type;
  final String? placeHolderUrl;

  const MyMediaPlayer({
    required this.url,
    required this.type,
    this.placeHolderUrl,
  });

  @override
  State<MyMediaPlayer> createState() => _MyMediaPlayerState();
}

class _MyMediaPlayerState extends State<MyMediaPlayer> {
  bool isVideoLoading = true;

  // network player controllers
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;

  // youtube video controllers
  PodPlayerController? youtubeController;
  double youtubeAspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    if (videoController != null) videoController!.dispose();
    if (youtubeController != null) youtubeController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == "image"
        ? CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: widget.url,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : isVideoLoading
            ? _videoPlaceHolder()
            : widget.type == "youtube"
                ? PodVideoPlayer(
                    controller: youtubeController!,
                    frameAspectRatio: youtubeAspectRatio,
                    videoAspectRatio: youtubeAspectRatio,
                  )
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
                  color: Styles.whiteColor,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                )
              : CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  imageUrl: widget.placeHolderUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
          Loader(),
        ],
      ),
    );
  }

  double? getVideoHeight() {
    if (widget.type == "video") {
      return (MediaQuery.of(context).size.width * videoController!.value.size.height) / videoController!.value.size.width;
    } else
      return null;
  }

  void initVideo() async {
    try {
      if (widget.type == "youtube") {
        youtubeController = PodPlayerController(
          playVideoFrom: PlayVideoFrom.youtube(widget.url),
        )..initialise();
        setState(() {
          if (widget.url.toLowerCase().contains("/shorts/")) youtubeAspectRatio = 9 / 16;
          isVideoLoading = false;
        });
      } else if (widget.type == "video") {
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
