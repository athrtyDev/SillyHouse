import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sillyhouseorg/utils/utils.dart';

class ActivityTypeWidget extends StatelessWidget {
  final String? type;
  const ActivityTypeWidget({Key? key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: type == 'diy'
                ? Colors.blue.withOpacity(0.7)
                : (type == 'science'
                    ? Colors.orange.withOpacity(0.7)
                    : (type == 'fun'
                        ? Colors.red.withOpacity(0.7)
                        : (type == "drawing" ? Colors.green.withOpacity(0.7) : Colors.blue.withOpacity(0.6)))),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        margin: EdgeInsets.fromLTRB(5, 4, 5, 4),
        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
        height: 25,
        child: Center(
            child: Text(Utils.getActivityTypeName(type).name!, style: GoogleFonts.kurale(color: Colors.white, fontSize: 11))));
  }
}
