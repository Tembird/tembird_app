class Todo {
  final String tid;
  final String todoTitle;
  final int todoStatus;
  final DateTime todoUpdatedAt;

  Todo({
    required this.tid,
    required this.todoTitle,
    required this.todoStatus,
    required this.todoUpdatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    tid: json['tid'],
    todoTitle: json['todo_title'],
    todoStatus: json['todo_status'],
    todoUpdatedAt: DateTime.parse(json["todo_updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "tid": tid,
    "todoTitle": todoTitle,
    "todoStatus": todoStatus,
  };
}

class TodoStatus1 {
  static const int notStarted = 0;
  static const int done = 1;
  static const int pass = 2;
}