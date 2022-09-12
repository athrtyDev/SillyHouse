import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class ChallengeType extends StatelessWidget {
  final String? name;
  final Widget? image;
  final Function? onTap;

  const ChallengeType({Key? key, this.name, this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap as void Function()?,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration:
                  new BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Styles.secondaryColor.withOpacity(0.2)),
              child: this.image,
            ),
          ),
          Text(
            this.name!,
            style: GoogleFonts.kurale(fontSize: 15, color: Styles.textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}
