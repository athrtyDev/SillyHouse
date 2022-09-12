import 'package:flutter/material.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/global/global.dart';
import 'package:sillyhouseorg/widgets/styles.dart';

class Utils {
  static ActivityType getActivityTypeName(String? type) {
    ActivityType returnType = new ActivityType(name: "");
    for (var item in app.activityTypes!) if (item.type == type) returnType = item;
    return returnType;
  }

  static DateTime? timestampToDate(dynamic time) {
    try {
      if (time == null) return null;
      var date = time.toDate();
      return date;
    } catch (_) {
      print("error timestampToDate ");
      return null;
    }
  }

  static String convertDate(dynamic value) {
    try {
      if (value == null) return "";
      String str = value.toString().substring(0, 10).replaceAll("-", ".");
      return str;
    } catch (_) {
      print("error convertDate ");
      return "";
    }
  }

  static Color getActivityTypeColor(String type) {
    switch (type) {
      case "fun":
        return Styles.baseColor3;
      case "diy":
        return Styles.baseColor5;
      case "dance":
        return Styles.baseColor2;
      case "drawing":
        return Styles.baseColor1;
      default:
        return Styles.baseColor1;
    }
  }

  static String getDifficultyName(String level) {
    switch (level) {
      case "easy":
        return "Анхан шат";
      case "medium":
        return "Дунд шат";
      case "hard":
        return "Айхтар шат";
      default:
        return "Дунд шат";
    }
  }
}
