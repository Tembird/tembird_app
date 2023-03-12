import 'package:flutter/material.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import '../../model/Schedule.dart';

class TodoList extends StatefulWidget {
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) onTapTodo;
  final Future<void> Function(Schedule schedule) changeStatus;

  const TodoList({Key? key, required this.scheduleList, required this.onTapTodo, required this.changeStatus}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          widget.scheduleList.length,
          (index) => _buildTodoListItem(
            schedule: widget.scheduleList[index],
            onTapTodo: widget.onTapTodo,
          ),
        ),
      ),
    );
  }

  void changeTodoStatus(Schedule schedule) async {
    await widget.changeStatus(schedule);
    print('======> isChanged');
  }

  Widget _buildTodoListItem({required Schedule schedule, required void Function(Schedule) onTapTodo}) {
    return schedule.scheduleTitle == null
        ? Container()
        : SizedBox(
            height: 50,
            child: Row(
              children: [
                InkWell(
                  onTap: () => changeTodoStatus(schedule),
                  child: Image.asset(
                    schedule.scheduleDone ? AssetNames.checkboxMarked : AssetNames.checkboxBlank,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => onTapTodo(schedule),
                    child: Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: StyledPalette.GRAY, width: 1))),
                      child: Text(
                        schedule.scheduleTitle!,
                        style: StyledFont.BODY,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
