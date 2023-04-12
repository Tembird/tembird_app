import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

import '../../constant/StyledPalette.dart';
import '../../model/DailyTodoLabel.dart';
import '../../model/Todo.dart';

class HomeTodoList extends GetView<HomeController> {
  const HomeTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.dailyTodoLabelList.isEmpty
        ? Center(
            child: Obx(() => controller.onLoading.isTrue
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
                          '오늘의 할일',
                          style: StyledFont.HEADLINE,
                        )
                      ],
                    ),
                  )),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => ListView.separated(
                itemCount: controller.dailyTodoLabelList.length,
                itemBuilder: (_, index) => DailyTodoLabelItem(index: index),
                separatorBuilder: (_, index) => const SizedBox(height: 16),
              ),
            ),
          ));
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
              Container(
                height: 40,
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: controller.hexToColor(colorHex: dailyTodoLabel.colorHex),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            dailyTodoLabel.title,
                            style: StyledFont.HEADLINE_WHITE,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            dailyTodoLabel.todoList.length.toString(),
                            style: StyledFont.CALLOUT_WHITE,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        remainingItemCount == 0 ? '🥳' : '$remainingItemCount개 남음',
                        style: StyledFont.CALLOUT_GRAY,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.createDailyTodo(index: index),
                      child: Icon(
                        Icons.add,
                        color: controller.hexToColor(colorHex: dailyTodoLabel.colorHex),
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
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
                            if (todo.status == TodoStatus1.notStarted)
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
                                        onTap: () => controller.editDailyTodoTitle(dailyTodoLabelIndex: index, dailyTodoIndex: tIndex),
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

// class ScheduleItem extends GetView<HomeController> {
//   final Schedule schedule;
//
//   const ScheduleItem({Key? key, required this.schedule}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SizedBox(
//         height:
//             45 * (schedule.todoList.length + (controller.onCreateTodo.isFalse || controller.editingScheduleIndex.value != controller.scheduleList.indexOf(schedule) ? 1 : 2)) + 16,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: 45,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: controller.hexToColor(colorHex: schedule.colorHex),
//                 borderRadius: BorderRadius.circular(11),
//               ),
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => controller.showScheduleActionModal(schedule),
//                       child: Text(
//                         schedule.title ?? "제목 없음",
//                         style: StyledFont.BODY_WHITE,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () => controller.showTodoInputForm(schedule: schedule),
//                     child: const Icon(Icons.add, color: StyledPalette.WHITE, size: 24),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...schedule.todoList
//                 .map(
//                   (todo) => SizedBox(
//                     height: 45,
//                     child: Row(
//                       children: [
//                         if (todo.todoStatus == TodoStatus.done)
//                           GestureDetector(
//                             onTap: () => controller.onNotStated(schedule: schedule, todo: todo),
//                             onLongPress: () => controller.onPass(schedule: schedule, todo: todo),
//                             child: Image.asset(AssetNames.todoDone, width: 24, height: 24),
//                           ),
//                         if (todo.todoStatus == TodoStatus.pass)
//                           GestureDetector(
//                             onTap: () => controller.onDone(schedule: schedule, todo: todo),
//                             onLongPress: () => controller.onNotStated(schedule: schedule, todo: todo),
//                             child: Image.asset(AssetNames.todoPass, width: 24, height: 24),
//                           ),
//                         if (todo.todoStatus == TodoStatus.notStarted)
//                           GestureDetector(
//                             onTap: () => controller.onDone(schedule: schedule, todo: todo),
//                             onLongPress: () => controller.onPass(schedule: schedule, todo: todo),
//                             child: Image.asset(AssetNames.todoNotStarted, width: 24, height: 24),
//                           ),
//                         const SizedBox(width: 8),
//                         Obx(
//                           () => controller.scheduleList.indexOf(schedule) != controller.editingScheduleIndex.value ||
//                                   controller.scheduleList[controller.scheduleList.indexOf(schedule)].todoList.indexOf(todo) != controller.editingTodoIndex.value
//                               ? GestureDetector(
//                                   onTap: () => controller.showTodoActionModal(schedule: schedule, todo: todo),
//                                   child: Container(
//                                       height: 45,
//                                       alignment: Alignment.centerLeft,
//                                       padding: const EdgeInsets.symmetric(vertical: 4),
//                                       child: Text(todo.todoTitle, style: StyledFont.BODY, maxLines: 1)),
//                                 )
//                               : Expanded(
//                                   child: Container(
//                                     height: 45,
//                                     alignment: Alignment.centerLeft,
//                                     child: TextFormField(
//                                       autofocus: true,
//                                       controller: controller.todoEditingController,
//                                       textAlignVertical: TextAlignVertical.center,
//                                       decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
//                                       style: StyledFont.BODY,
//                                       textAlign: TextAlign.start,
//                                       onFieldSubmitted: (_) => controller.updateTodoTitle(schedule: schedule, todo: todo),
//                                       textInputAction: TextInputAction.done,
//                                     ),
//                                   ),
//                                 ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//             Obx(
//               () => controller.onCreateTodo.isFalse || controller.editingScheduleIndex.value != controller.scheduleList.indexOf(schedule)
//                   ? Container()
//                   : SizedBox(
//                       height: 45,
//                       child: TextFormField(
//                         autofocus: true,
//                         controller: controller.todoEditingController,
//                         textAlignVertical: TextAlignVertical.center,
//                         decoration: const InputDecoration(
//                             hintText: '할일 추가 +', hintStyle: StyledFont.BODY_GRAY, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 4)),
//                         style: StyledFont.BODY,
//                         textAlign: TextAlign.start,
//                         onFieldSubmitted: (_) => controller.createTodo(schedule: schedule),
//                         textInputAction: TextInputAction.done,
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }
