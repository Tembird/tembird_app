import 'DailyTodo.dart';

class DailyTodoLabel {
  final int id;
  final int labelId;
  String title;
  String colorHex;
  final int date;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<DailyTodo> todoList;

  DailyTodoLabel({
    required this.id,
    required this.labelId,
    required this.title,
    required this.colorHex,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.todoList,
  });

  factory DailyTodoLabel.fromJson(Map<String, dynamic> json) => DailyTodoLabel(
    id: json['id'],
    labelId: json['label_id'],
    title: json['title'],
    colorHex: json['color_hex'],
    date: json['date'],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    todoList: json['todo_list'] == null ? [] : (json['todo_list'] as List).map((e) => DailyTodo.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "labelId": labelId,
    "title": title,
    "colorHex": colorHex,
    "date": date,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "todoList": todoList.map((e) => e.toJson()).toList(),
  };
}