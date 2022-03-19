import 'dart:io';
import 'package:video_player/video_player.dart';

class Media {
  String url;
  String type;
  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;
  String cachePath;
  // tuslah
  File file;

  Media({this.url, this.type, this.file});
}
