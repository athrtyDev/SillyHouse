import 'dart:io';

class PickedMedia {
  String? path;
  String? type; // image, video
  File? storageFile;

  PickedMedia({this.path, this.type, this.storageFile});
}
