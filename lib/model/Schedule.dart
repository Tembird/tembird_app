import 'dart:math';

class Schedule {
  final int scheduleId;
  final List<Point<int>> schedulePointList;
  final String scheduleColorHex;
  final String scheduleName;
  final String scheduleDetail;
  bool scheduleDone;

  Schedule({
    required this.scheduleId,
    required this.schedulePointList,
    required this.scheduleColorHex,
    required this.scheduleName,
    required this.scheduleDetail,
    required this.scheduleDone,
  });
}
