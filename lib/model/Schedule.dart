import 'dart:math';

class Schedule {
  final int scheduleId;
  final DateTime scheduleDate;
  final List<int> scheduleIndexList;
  final String scheduleColorHex;
  final String scheduleName;
  final String scheduleDetail;
  bool scheduleDone;

  Schedule({
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleIndexList,
    required this.scheduleColorHex,
    required this.scheduleName,
    required this.scheduleDetail,
    required this.scheduleDone,
  });
}
