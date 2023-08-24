import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';

class DetailTodoDialogArgument {
  final DateTime date;
  final DailyTodoLabel todoLabel;
  final DailyTodo todo;

  DetailTodoDialogArgument({
    required this.date,
    required this.todoLabel,
    required this.todo,
  });
}
