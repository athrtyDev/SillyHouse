import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnImageText extends StatelessWidget {
  final String? text;
  final double textSize;

  const OnImageText({this.text, this.textSize = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        color: Colors.white.withOpacity(0.7),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(text!, style: GoogleFonts.kurale(fontSize: this.textSize, color: Colors.black54, fontWeight: FontWeight.w600)),
    );
  }
}
