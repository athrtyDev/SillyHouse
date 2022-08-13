import 'package:sillyhouseorg/core/classes/activity.dart';

abstract class ActivityState {}

class ActivityInitState extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityLoaded extends ActivityState {
  Map<String?, List<Activity>?> mapActivity;

  ActivityLoaded({required this.mapActivity});

  @override
  List<Object?> get props => [mapActivity];
}
