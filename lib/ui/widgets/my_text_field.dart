import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? icon;
  final String? hintText;
  final bool isPassword;
  final FocusNode? focusNode;
  final Color borderColor;
  final Function? onTap;

  MyTextField(
      {this.controller,
      this.keyboardType,
      this.icon,
      this.hintText,
      this.isPassword = false,
      this.focusNode,
      this.borderColor = Colors.transparent,
      this.onTap = null});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: new BorderSide(color: widget.borderColor), borderRadius: BorderRadius.all(Radius.circular(15)));
    return Container(
      height: 60,
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: GoogleFonts.kurale(color: Colors.black),
        onTap: () {
          if (widget.onTap != null) widget.onTap!();
          setState(() {});
        },
        obscureText: widget.isPassword,
        textInputAction: TextInputAction.next,
        focusNode: widget.focusNode,
        onSubmitted: (str) {
          setState(() {});
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: widget.controller!.text != null && widget.controller!.text != "" ? Colors.black38 : Colors.grey[300],
            ),
            suffixIcon: widget.controller!.text != null && widget.controller!.text != ""
                ? Icon(Icons.check_circle_rounded, color: Colors.green)
                : null,
            border: border,
            focusedBorder: border,
            disabledBorder: border,
            enabledBorder: border,
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.kurale(
                color: Colors.grey[400], fontWeight: FontWeight.w100, fontStyle: FontStyle.italic, fontSize: 16.0)),
      ),
    );
  }
}
