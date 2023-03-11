import 'package:flutter/material.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import '../../model/Schedule.dart';

class TodoList extends StatefulWidget {
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) onTapTodo;

  const TodoList({Key? key, required this.scheduleList, required this.onTapTodo}) : super(key: key);

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

  Widget _buildTodoListItem({required Schedule schedule, required void Function(Schedule) onTapTodo}) {
    return schedule.scheduleTitle == null
        ? Container()
        : SizedBox(
            height: 50,
            child: Row(
              children: [
                // SizedBox(
                //   width: 24,
                //   child: InkWell(
                //     onTap: changeTodoState,
                //     child: CircleAvatar(
                //       radius: 12,
                //       backgroundColor: StyledPalette.GRAY,
                //       child: CircleAvatar(
                //         radius: 10,
                //         backgroundColor: schedule.scheduleDone ? StyledPalette.STATUS_INFO : StyledPalette.MINERAL,
                //       ),
                //     ),
                //   ),
                // ),
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
