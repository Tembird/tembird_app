class Schedule {
  final String sid;
  final DateTime date;
  final List<int> scheduleIndexList;
  final int startAt;
  final int endAt;
  final String colorHex;
  final String? title;
  final String? detail;
  final String? location;
  final List<String> memberList;
  final DateTime createdAt;
  DateTime editedAt;
  bool done;
  DateTime? doneAt;

  Schedule({
    required this.sid,
    required this.date,
    required this.startAt,
    required this.endAt,
    required this.scheduleIndexList,
    required this.colorHex,
    this.title,
    this.detail,
    this.location,
    required this.memberList,
    required this.createdAt,
    required this.editedAt,
    this.done = false,
    this.doneAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    int startAt = json["start_at"];
    int endAt = json["end_at"];
    return Schedule(
      sid: json['sid'],
      date: DateTime.parse(json["date"]),
      scheduleIndexList: List.generate(endAt - startAt + 1, (index) => startAt + index),
      colorHex: json["color_hex"],
      startAt: startAt,
      endAt: endAt,
      title: json["title"],
      detail: json["detail"],
      location: json["location"],
      memberList: (json["member_list"] as String).split(','),
      done: json["done"] == 1,
      doneAt: json["done_at"] == null ? null : DateTime.parse(json["done_at"]),
      createdAt: DateTime.parse(json["created_at"]),
      editedAt: DateTime.parse(json["edited_at"]),
    );
  }

  // Map<String, dynamic> toJson() => {
  //   "sid": sid,
  //   "date": DateFormat('yyMMdd').format(date),
  //   "colorHex": colorHex,
  //   "startAt": scheduleIndexList.first,
  //   "endAt": scheduleIndexList.last,
  //   "title": title,
  //   "detail": detail,
  //   "location": location,
  //   "memberList": memberList.toString(),
  //   "done": done,
  //   "doneAt": doneAt,
  // };
}
