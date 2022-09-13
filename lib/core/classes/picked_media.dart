import 'dart:io';

class MyMediaObject {
  String path;
  String type; // image, video
  File storageFile;
  bool? isSelfie;

  MyMediaObject({required this.path, required this.type, required this.storageFile, this.isSelfie = false});
}
