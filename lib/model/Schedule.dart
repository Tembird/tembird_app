import 'dart:math';

class Schedule {
  final int scheduleId;
  final DateTime scheduleDate;
  final List<int> scheduleIndexList;
  final String scheduleColorHex;
  final String scheduleTitle;
  final String? scheduleDetail;
  final String? scheduleLocation;
  final List<String> scheduleMember;
  bool scheduleDone;

  Schedule({
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleIndexList,
    required this.scheduleColorHex,
    required this.scheduleTitle,
    this.scheduleDetail,
    this.scheduleLocation,
    required this.scheduleMember,
    required this.scheduleDone,
  });
}
