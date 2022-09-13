import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/utils/media_controller.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ProfilePicture extends StatelessWidget {
  final File? file;
  final String? url;
  final Function? onTap;
  final bool isSelfie;

  ProfilePicture({this.file, this.url, this.onTap, this.isSelfie = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              // border: Border.all(color: file == null && url == null ? Colors.transparent : Styles.baseColor1),
              color: Styles.textColor10,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: file == null && url == null
                ? FittedBox(
                    child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.add_a_photo_rounded, color: Styles.textColor50),
                  ))
                : isSelfie
                    ? mediaController.getFlippedImage(_image())
                    : _image(),
          ),
        ],
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      child: file != null
          ? Image.file(file!, fit: BoxFit.cover)
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: url!,
              errorWidget: (context, url, error) => Icon(Icons.person_outline_rounded, size: 18),
            ),
    );
  }
}
