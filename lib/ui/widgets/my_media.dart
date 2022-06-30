import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/enums/view_state.dart';
import 'package:video_player/video_player.dart';

class MyMedia extends StatefulWidget {
  final String? url;
  final String? type;
  final Function? onDispose;

  const MyMedia({required this.url, required this.type, this.onDispose});

  @override
  State<MyMedia> createState() => _MyMediaState();
}

class _MyMediaState extends State<MyMedia> {
  VideoPlayerController? videoController;
  Future<void>? initializeVideoPlayer;
  ViewState? state;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  _disposeVideo() {
    if (videoController != null) videoController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return state == ViewState.Busy
        ? Container(height: 300, child: Center(child: CircularProgressIndicator()))
        : Container(
            height: (widget.type == 'video' && videoController!.value.size != null)
                ? ((MediaQuery.of(context).size.width * videoController!.value.size.height) / videoController!.value.size.width)
                : null,
            width: widget.type == 'video' ? MediaQuery.of(context).size.width : null,
            child: widget.type == 'image'
                ? CachedNetworkImage(
                    imageUrl: widget.url!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                :
                // Video instruction
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
                  ),
          );
  }

  void initVideo() async {
    try {
      setState(() {
        state = ViewState.Busy;
      });
      // initialize video
      if (widget.type == 'video') {
        videoController = VideoPlayerController.network(widget.url!);
        await videoController!.initialize();
        videoController!.setLooping(false);
        videoController!.setVolume(4.0);
        videoController!.play();
      }
      setState(() {
        state = ViewState.Idle;
      });
    } catch (ex) {
      print('error on loadPostVideo: ' + ex.toString());
    }
  }
}
