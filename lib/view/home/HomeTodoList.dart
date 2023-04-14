import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

import '../../constant/StyledPalette.dart';
import '../../model/DailyTodoLabel.dart';

class HomeTodoList extends GetView<HomeController> {
  const HomeTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.dailyTodoLabelList.isEmpty
          ? Center(
              child: Obx(
                () => controller.onLoading.isTrue
                    ? const Text(
                        '불러오는 중..',
                        style: StyledFont.HEADLINE,
                      )
                    : GestureDetector(
                        onTap: controller.createDailyTodoAndLabel,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, size: 24),
                            SizedBox(height: 8),
                            Text(
                              '할일 추가',
                              style: StyledFont.HEADLINE,
                            )
                          ],
                        ),
                      ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.dailyTodoLabelList.length + 1,
                  itemBuilder: (_, index) {
                    if (index == controller.dailyTodoLabelList.length) {
                      return const AddTodoButton();
                    }
                    return DailyTodoLabelItem(index: index);
                  },
                  separatorBuilder: (_, index) => const SizedBox(height: 16),
                ),
              ),
            ),
    );
  }
}

class DailyTodoLabelItem extends GetView<HomeController> {
  final int index;

  const DailyTodoLabelItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final DailyTodoLabel dailyTodoLabel = controller.dailyTodoLabelList[index];
        int remainingItemCount = dailyTodoLabel.todoList.where((e) => e.status == TodoStatus.notStarted).length;
        return SizedBox(
          height: 45 * (dailyTodoLabel.todoList.length + 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 37,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              height: 37,
                              decoration: BoxDecoration(
                                color: controller.hexToColor(colorHex: dailyTodoLabel.colorHex),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dailyTodoLabel.title,
                                    style: StyledFont.HEADLINE_WHITE,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          remainingItemCount == 0
                              ? const Text(
                                  '모두 완료했어요 😄',
                                  style: StyledFont.CALLOUT_700_POSITIVE,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  '$remainingItemCount개 남았어요 🤗',
                                  style: StyledFont.CALLOUT_700_GRAY,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.createDailyTodo(index: index),
                      child: Icon(
                        Icons.add,
                        color: controller.hexToColor(colorHex: dailyTodoLabel.colorHex),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (dailyTodoLabel.todoList.isNotEmpty)
                ...List.generate(
                  dailyTodoLabel.todoList.length,
                  (tIndex) => Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Obx(
                      () {
                        DailyTodo todo = controller.dailyTodoLabelList[index].todoList[tIndex];
                        return Row(
                          children: [
                            if (todo.status == TodoStatus.done)
                              GestureDetector(
                                onTap: () => controller.onNotStated(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                onLongPress: () => controller.onPass(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                child: Image.asset(AssetNames.todoDone, width: 24, height: 24),
                              ),
                            if (todo.status == TodoStatus.pass)
                              GestureDetector(
                                onTap: () => controller.onDone(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                onLongPress: () => controller.onNotStated(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                child: Image.asset(AssetNames.todoPass, width: 24, height: 24),
                              ),
                            if (todo.status == TodoStatus.notStarted)
                              GestureDetector(
                                onTap: () => controller.onDone(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                onLongPress: () => controller.onPass(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                child: Image.asset(AssetNames.todoNotStarted, width: 24, height: 24),
                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Obx(
                                () => index != controller.editingDailyTodoLabelIndex.value || tIndex != controller.editingDailyTodoIndex.value
                                    ? GestureDetector(
                                        onTap: () => controller.selectDailyTodoTitle(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                        child: Container(
                                          height: 45,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                            todo.title,
                                            style: StyledFont.BODY,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 45,
                                        alignment: Alignment.centerLeft,
                                        child: TextFormField(
                                          autofocus: true,
                                          controller: controller.todoEditingController,
                                          textAlignVertical: TextAlignVertical.center,
                                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
                                          style: StyledFont.BODY,
                                          textAlign: TextAlign.start,
                                          onFieldSubmitted: (_) => controller.updateDailyTodoTitle(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                              ),
                            ),
                            if (todo.location != null)
                              GestureDetector(
                                onTap: () => controller.openDailyTodoDetailDialog(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: StyledPalette.GRAY,
                                  ),
                                ),
                              ),
                            if (todo.detail != null)
                              GestureDetector(
                                onTap: () => controller.openDailyTodoDetailDialog(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.article_outlined,
                                    size: 18,
                                    color: StyledPalette.GRAY,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => controller.showTodoActionModal(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
                              child: const Icon(
                                Icons.more_horiz_outlined,
                                size: 24,
                                color: StyledPalette.BLACK10,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class AddTodoButton extends GetView<HomeController> {
  const AddTodoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.createDailyTodoAndLabel,
      child: SizedBox(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('할일 추가', style: StyledFont.CALLOUT_700),
            SizedBox(width: 4),
            Icon(Icons.add, size: 24, color: StyledPalette.BLACK,)
          ],
        ),
      ),
    );
  }
}
