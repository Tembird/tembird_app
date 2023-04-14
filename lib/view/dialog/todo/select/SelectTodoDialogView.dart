import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/view/dialog/todo/select/controller/SelectTodoDialogController.dart';

import '../../../../constant/StyledFont.dart';
import '../../../../model/DailyTodo.dart';

class SelectTodoDialogView extends GetView<SelectTodoDialogController> {
  const SelectTodoDialogView({Key? key}) : super(key: key);

  static route({required List<DailyTodoLabel> dailyTodoLabelList, required int startAt, required int endAt}) {
    return GetBuilder(
      init: SelectTodoDialogController(dailyTodoLabelList: dailyTodoLabelList, startAt: startAt, endAt: endAt),
      builder: (_) => const SelectTodoDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyledPalette.MINERAL,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        constraints: BoxConstraints(maxHeight: Get.height / 2),
        child: controller.dailyTodoLabelList.isEmpty
            ? const Text(
                '일정이 없습니다',
                style: StyledFont.BODY,
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemCount: controller.dailyTodoLabelList.length + 1,
                separatorBuilder: (context, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Text(
                      '할일 선택',
                      style: StyledFont.HEADLINE,
                    );
                  }
                  final int lIndex = index - 1;
                  final DailyTodoLabel dailyTodoLabel = controller.dailyTodoLabelList[lIndex];
                  return SizedBox(
                    height: 45 + (dailyTodoLabel.todoList.length * 53),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dailyTodoLabel.title,
                            style: StyledFont.HEADLINE.copyWith(
                              color: controller.hexToColor(colorHex: dailyTodoLabel.colorHex),
                            ),
                          ),
                        ),
                        ...List.generate(
                          dailyTodoLabel.todoList.length,
                          (tIndex) {
                            final DailyTodo dailyTodo = dailyTodoLabel.todoList[tIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: GestureDetector(
                                onTap: () => controller.updateSelectedDailyTodoDuration(dailyTodoLabelIndex: lIndex, dailyTodoIndex: tIndex),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: dailyTodo.startAt == null || dailyTodo.endAt == null ? controller.hexToColor(colorHex: dailyTodoLabel.colorHex) : StyledPalette.BLACK10,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  height: 45,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          dailyTodo.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: StyledFont.FOOTNOTE_500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        dailyTodo.startAt == null || dailyTodo.endAt == null ?  '미정' : 'From: ${controller.indexToTimeString(index: dailyTodo.startAt!)}\nTo: ${controller.indexToTimeString(index: dailyTodo.endAt!)}',
                                        style: StyledFont.CAPTION_1,
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
