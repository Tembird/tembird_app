import 'Schedule.dart';

enum ActionType {
  created,
  updated,
  removed,
}

class ScheduleAction {
  final ActionType action;
  final Schedule? schedule;

  ScheduleAction({
    required this.action,
    this.schedule,
  });
}
