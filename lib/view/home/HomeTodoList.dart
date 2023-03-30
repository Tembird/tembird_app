import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

import '../../model/Schedule.dart';
import '../../model/Todo.dart';

class HomeTodoList extends GetView<HomeController> {
  const HomeTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              controller.scheduleList.length,
              (index) => ScheduleItem(schedule: controller.scheduleList[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleItem extends GetView<HomeController> {
  final Schedule schedule;

  const ScheduleItem({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (schedule.todoList.isEmpty) return Container();
    return GestureDetector(
      onLongPress: () => controller.showScheduleActionModal(schedule),
      child: SizedBox(
        height: 45 * (schedule.todoList.length + 1) + 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: controller.hexToColor(colorHex: schedule.colorHex),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  schedule.title!,
                  style: StyledFont.BODY_WHITE,
                  maxLines: 1,
                ),
              ),
            ),
            ...schedule.todoList
                .map((todo) => GestureDetector(
                      child: SizedBox(
                        height: 45,
                        child: Row(
                          children: [
                            if (todo.todoStatus == TodoStatus.done)
                              GestureDetector(
                                onTap: () => controller.onNotStated(schedule: schedule, todo: todo),
                                onLongPress: () => controller.onPass(schedule: schedule, todo: todo),
                                child: Image.asset(AssetNames.todoDone, width: 24, height: 24),
                              ),
                            if (todo.todoStatus == TodoStatus.pass)
                              GestureDetector(
                                onTap: () => controller.onDone(schedule: schedule, todo: todo),
                                onLongPress: () => controller.onNotStated(schedule: schedule, todo: todo),
                                child: Image.asset(AssetNames.todoPass, width: 24, height: 24),
                              ),
                            if (todo.todoStatus == TodoStatus.notStarted)
                              GestureDetector(
                                onTap: () => controller.onDone(schedule: schedule, todo: todo),
                                onLongPress: () => controller.onPass(schedule: schedule, todo: todo),
                                child: Image.asset(AssetNames.todoNotStarted, width: 24, height: 24),
                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(todo.todoTitle, style: StyledFont.BODY, maxLines: 1),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
