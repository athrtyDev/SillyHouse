import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';

class ProfilePicture extends StatelessWidget {
  final File? file;
  final String? url;
  final Function? onTap;

  ProfilePicture({this.file, this.url, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: file == null && url == null ? Colors.transparent : AppColors.baseColor),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: file == null && url == null
                ? FittedBox(
                    child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.add_a_photo_rounded, color: Colors.grey[300]),
                  ))
                : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    child: file != null
                        ? Image.file(file!, fit: BoxFit.cover)
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: url!,
                            errorWidget: (context, url, error) => Icon(Icons.error_outline),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
