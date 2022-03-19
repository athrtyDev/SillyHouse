import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/ui/globals/color.dart';

class IconAndText extends StatelessWidget {
  final Icon icon;
  final String text;
  final bool isHorizontal;

  const IconAndText({this.icon, this.text, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    return this.isHorizontal
        ? Row(
            children: [
              this.icon,
              SizedBox(width: 8),
              Text(this.text,
                  style: GoogleFonts.kurale(
                    fontSize: 18,
                    color: AppColors.mainTextColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  )),
            ],
          )
        : Column(
            children: [
              this.icon,
              SizedBox(height: 8),
              Text(this.text,
                  style: GoogleFonts.kurale(
                    fontSize: 18,
                    color: AppColors.mainTextColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  )),
            ],
          );
  }
}
