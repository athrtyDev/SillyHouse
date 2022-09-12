import 'dart:io';
import 'package:images_picker/images_picker.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';

MediaController mediaController = MediaController();

class MediaController {
  Future<MyMediaObject?> galleryPicker({String? type}) async {
    try {
      PickType pickType = type == null
          ? PickType.all
          : type == "image"
              ? PickType.image
              : PickType.video;
      List<Media>? listSelected = await ImagesPicker.pick(pickType: pickType, count: 1);
      if (listSelected != null && listSelected.isNotEmpty) {
        MyMediaObject media = new MyMediaObject(
          type: listSelected[0].path.endsWith("mp4") ? "video" : "image",
          path: listSelected[0].path,
          storageFile: File(listSelected[0].path),
        );
        return media;
      } else
        return null;
    } catch (e) {
      return null;
    }
  }
}
