import 'dart:io';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:sillyhouseorg/core/classes/picked_media.dart';
import 'dart:math' as math;

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
          type: listSelected[0].path.toLowerCase().endsWith("mp4") || listSelected[0].path.toLowerCase().endsWith("mov")
              ? "video"
              : "image",
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

  Widget getFlippedImage(Widget image) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: image,
    );
  }
}
