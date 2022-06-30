import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/services/api.dart';
import 'package:sillyhouseorg/core/viewmodels/base_model.dart';
import 'package:sillyhouseorg/locator.dart';

class AdminModel extends BaseModel {
  final Api? _api = locator<Api>();
  Map<String, List<Activity>>? mapActivity;
}
