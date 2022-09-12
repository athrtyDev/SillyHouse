import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/constant.dart';
import 'package:sillyhouseorg/widgets/back_button.dart';
import 'package:sillyhouseorg/widgets/my_text.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

PreferredSizeWidget myAppBar({
  Function? leadingFunction,
  String? title,
  Widget? titleWidget,
  Color? textColor,
}) {
  return AppBar(
    backgroundColor: Styles.whiteColor,
    leading: InkWell(
      onTap: () {
        if (leadingFunction != null)
          leadingFunction();
        else
          NavKey.currentState!.pop();
      },
      child: MyBackButton(),
    ),
    shadowColor: Colors.transparent,
    title: titleWidget != null
        ? titleWidget
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              MyText.xlarge(
                title!,
                textColor: textColor ?? Styles.textColor,
              ),
            ],
          ),
  );
}
