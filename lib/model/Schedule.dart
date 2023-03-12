import 'dart:math';

class Schedule {
  final int scheduleId;
  final DateTime scheduleDate;
  final List<int> scheduleIndexList;
  final String scheduleColorHex;
  final String? scheduleTitle;
  final String? scheduleDetail;
  final String? scheduleLocation;
  final List<String> scheduleMember;
  bool scheduleDone;

  Schedule({
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleIndexList,
    required this.scheduleColorHex,
    this.scheduleTitle,
    this.scheduleDetail,
    this.scheduleLocation,
    required this.scheduleMember,
    required this.scheduleDone,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    scheduleId: json['scheduleId'],
    scheduleDate: DateTime.parse(json["scheduleDate"]),
    scheduleIndexList: (json["scheduleIndexList"] as List<String>).map((e) => int.parse(e)).toList(),
    scheduleColorHex: json["scheduleColorHex"],
    scheduleTitle: json["scheduleTitle"],
    scheduleDetail: json["scheduleDetail"],
    scheduleLocation: json["scheduleLocation"],
    scheduleMember: json["scheduleMember"] as List<String>,
    scheduleDone: json["scheduleDone"],
  );

  Map<String, dynamic> toJson() => {
    "scheduleId": scheduleId,
    "scheduleDate": scheduleDate.toString(),
    "scheduleIndexList": scheduleIndexList.toString(),
    "scheduleColorHex": scheduleColorHex,
    "scheduleTitle": scheduleTitle,
    "scheduleDetail": scheduleDetail,
    "scheduleLocation": scheduleLocation,
    "scheduleMember": scheduleMember.toString(),
    "scheduleDone": scheduleDone,
  };
}
