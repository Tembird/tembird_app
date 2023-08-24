import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/model/TodoLabel.dart';

enum ActionResultType {
  created,
  updated,
  removed,
}

class ActionResult {
  final ActionResultType action;
  final DailyTodoLabel? dailyTodoLabel;
  final DailyTodo? dailyTodo;
  final TodoLabel? todoLabel;
  final int? dailyTodoLabelIndex;
  final int? dailyTodoIndex;

  ActionResult({
    required this.action,
    this.dailyTodoLabel,
    this.dailyTodo,
    this.todoLabel,
    this.dailyTodoLabelIndex,
    this.dailyTodoIndex,
  });
}
