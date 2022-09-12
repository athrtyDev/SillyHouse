import 'package:flutter/material.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class Button extends StatelessWidget {
  final double? width;
  final String text;
  final Function? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color buttonColor;
  final Color? textColor;
  final IconData? icon;
  final Border? border;
  final Widget? iconSvg;
  final bool? hasShadow;

  Button({
    Key? key,
    this.width,
    this.text = '',
    this.onTap,
    this.padding,
    this.margin,
    this.icon,
    this.iconSvg,
  })  : buttonColor = Styles.baseColor1,
        textColor = Styles.whiteColor,
        border = Border.all(width: 0, color: Colors.transparent),
        hasShadow = true;

  Button.disabled({
    this.width,
    this.text = '',
    this.onTap,
    this.padding,
    this.margin,
    this.icon,
    this.iconSvg,
  })  : buttonColor = Styles.baseColor1.withOpacity(0.3),
        textColor = Styles.whiteColor,
        border = Border.all(width: 0, color: Colors.transparent),
        hasShadow = false;

  Button.secondary({
    this.width,
    this.text = '',
    this.onTap,
    this.padding,
    this.margin,
    this.icon,
    this.iconSvg,
  })  : buttonColor = Styles.textColor,
        textColor = Styles.whiteColor,
        border = Border.all(width: 0, color: Colors.transparent),
        hasShadow = false;

  Button.accent({
    this.width,
    this.text = '',
    this.onTap,
    this.padding,
    this.margin,
    this.icon,
    this.iconSvg,
  })  : buttonColor = Styles.baseColor4,
        textColor = Styles.whiteColor,
        border = Border.all(width: 0, color: Colors.transparent),
        hasShadow = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 55,
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: buttonColor,
            border: border,
            borderRadius: BorderRadius.circular(5),
            boxShadow: hasShadow != null
                ? [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null),
        width: width ?? null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (icon != null)
                  Container(
                    child: Icon(icon, color: textColor),
                    padding: EdgeInsets.only(right: 2),
                  ),
                if (iconSvg != null)
                  Container(
                    height: 10,
                    child: iconSvg,
                    padding: EdgeInsets.only(right: 3),
                  ),
                MyText.medium(
                  text,
                  textAlign: TextAlign.center,
                  fontWeight: Styles.wBold,
                  textColor: textColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
