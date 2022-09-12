import 'package:sillyhouseorg/core/classes/activity.dart';
import 'package:sillyhouseorg/core/classes/activity_type.dart';

abstract class ActivityState {}

class ActivityInitState extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  Map<String?, List<Activity>?> mapActivity;
  List<ActivityType> listActivityType;

  ActivityLoaded({required this.mapActivity, required this.listActivityType});

  @override
  List<Object?> get props => [mapActivity, listActivityType];
}
