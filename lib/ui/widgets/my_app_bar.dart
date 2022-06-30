import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';

Widget myAppBar({Function? leadingFunction, String? title, Widget? titleWidget}) {
  return AppBar(
    backgroundColor: AppColors.whiteColor,
    leading: InkWell(
      onTap: leadingFunction as void Function()?,
      child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textColor),
    ),
    title: titleWidget != null
        ? titleWidget
        : Text(title!,
            style: GoogleFonts.kurale(
              fontSize: 18,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            )),
  );
}
