import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

import '../../constant/StyledPalette.dart';
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
    return Obx(
      () => SizedBox(
        height: 45 * (schedule.todoList.length + (controller.onCreateTodo.isFalse || controller.editingScheduleIndex.value != controller.scheduleList.indexOf(schedule) ? 1 : 2)) + 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: controller.hexToColor(colorHex: schedule.colorHex),
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.showScheduleActionModal(schedule),
                      child: Text(
                        schedule.title!,
                        style: StyledFont.BODY_WHITE,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.showTodoInputForm(schedule: schedule),
                    child: const Icon(Icons.add, color: StyledPalette.WHITE, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...schedule.todoList
                .map(
                  (todo) => SizedBox(
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
                        Obx(
                          () => controller.scheduleList.indexOf(schedule) != controller.editingScheduleIndex.value ||
                                  controller.scheduleList[controller.scheduleList.indexOf(schedule)].todoList.indexOf(todo) != controller.editingTodoIndex.value
                              ? GestureDetector(
                                  onTap: () => controller.showTodoActionModal(schedule: schedule, todo: todo),
                                  child: Container(
                                      height: 45,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(todo.todoTitle, style: StyledFont.BODY, maxLines: 1)),
                                )
                              : Expanded(
                                  child: Container(
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: controller.todoEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                                      style: StyledFont.BODY,
                                      textAlign: TextAlign.start,
                                      onFieldSubmitted: (_) => controller.updateTodoTitle(schedule: schedule, todo: todo),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
            Obx(
              () => controller.onCreateTodo.isFalse || controller.editingScheduleIndex.value != controller.scheduleList.indexOf(schedule)
                  ? Container()
                  : SizedBox(
                      height: 45,
                      child: TextFormField(
                        autofocus: true,
                        controller: controller.todoEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            hintText: '할일 추가 +', hintStyle: StyledFont.BODY_GRAY, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                        style: StyledFont.BODY,
                        textAlign: TextAlign.start,
                        onFieldSubmitted: (_) => controller.createTodo(schedule: schedule),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
