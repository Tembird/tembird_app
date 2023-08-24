class DailyTodo {
  final int id;
  String title;
  int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  int? startAt;
  int? endAt;
  String? location;
  String? detail;

  DailyTodo({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.startAt,
    this.endAt,
    this.location,
    this.detail,
  });

  factory DailyTodo.fromJson(Map<String, dynamic> json) => DailyTodo(
    id: json['id'],
    title: json['title'],
    status: json['status'],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    startAt: json['start_at'],
    endAt: json['end_at'],
    location: json['location'],
    detail: json['detail'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "startAt": startAt,
    "endAt": endAt,
    "location": location,
    "detail": detail,
  };
}

class TodoStatus {
  static const int notStarted = 0;
  static const int done = 1;
  static const int pass = 2;
}