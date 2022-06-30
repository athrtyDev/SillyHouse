import 'package:sillyhouseorg/core/classes/activity_type.dart';
import 'package:sillyhouseorg/global/global.dart';

class Utils {
  static ActivityType getActivityTypeName(String? type) {
    ActivityType returnType = new ActivityType(name: "");
    if (app.activityTypes != null) {
      for (var item in app.activityTypes!) if (item.type == type) returnType = item;
    }
    return returnType;
  }
}
