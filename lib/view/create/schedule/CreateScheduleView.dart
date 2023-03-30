import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/view/create/schedule/controller/CreateScheduleController.dart';

import '../../../constant/AssetNames.dart';
import '../../../model/Todo.dart';
import '../../ads/FloatingBannerAdView.dart';

class CreateScheduleView extends GetView<CreateScheduleController> {
  const CreateScheduleView({Key? key}) : super(key: key);

  static route(Schedule schedule, bool isNew) {
    return GetBuilder(
      init: CreateScheduleController(schedule: schedule, isNew: isNew),
      builder: (_) => const CreateScheduleView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.onLoading.isTrue
          ? Container()
          : GestureDetector(
              onVerticalDragStart: (DragStartDetails details) => controller.dragStart(details.globalPosition.dy),
              onVerticalDragCancel: controller.dragCancel,
              onVerticalDragUpdate: (DragUpdateDetails details) => controller.dragUpdate(details.globalPosition.dy),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
                child: Column(
                  children: [
                    Obx(
                      () => SizedBox(
                        height: controller.onEditing.isFalse ? 200 : 50,
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: controller.cancelSchedule,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.tapAds,
                      child: const FloatingBannerAdView(),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.hideKeyboard,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: StyledPalette.MINERAL,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: controller.cancelSchedule,
                                    child: const Text('취소', style: StyledFont.CALLOUT_GRAY),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          controller.selectedDateText,
                                          style: StyledFont.HEADLINE,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          controller.selectedScheduleTimeText,
                                          style: StyledFont.FOOTNOTE,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: controller.saveSchedule,
                                    child: const Text("저장", style: StyledFont.CALLOUT_INFO),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.titleController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '일정 제목',
                                        hintStyle: StyledFont.TITLE_2_GRAY,
                                      ),
                                      style: StyledFont.TITLE_2_700,
                                      textAlign: TextAlign.left,
                                      onTap: controller.onEdit,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: controller.changeStatus,
                                    child: Obx(
                                      () => Image.asset(
                                        controller.scheduleDone.isTrue ? AssetNames.checkboxMarked : AssetNames.checkboxBlank,
                                        width: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Expanded(
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Obx(() => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      controller.scheduleColorHexList.isNotEmpty
                                          ? SizedBox(
                                        height: 45,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: controller.scheduleColorHexList
                                                .map(
                                                  (e) => Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Column(
                                                  children: [
                                                    controller.scheduleColorHex.value == e
                                                        ? const CircleAvatar(
                                                      radius: 2,
                                                      backgroundColor: StyledPalette.STATUS_INFO,
                                                    )
                                                        : const SizedBox(height: 4),
                                                    const SizedBox(height: 4),
                                                    InkWell(
                                                      onTap: () => controller.changeColorHex(e),
                                                      radius: 12,
                                                      child: CircleAvatar(
                                                        radius: controller.scheduleColorHex.value == e ? 16 : 12,
                                                        backgroundColor: Color(int.parse(e, radix: 16) + 0xFF000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                                .toList(),
                                          ),
                                        ),
                                      )
                                          : Container(),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '할 일 목록',
                                        style: StyledFont.CAPTION_1_GRAY,
                                        maxLines: 1,
                                      ),
                                      ...List.generate(controller.todoList.length, (index) =>
                                          GestureDetector(
                                            onTap: () => controller.showTodoInfo(index),
                                            child: TodoItem(todo: controller.todoList[index]),
                                          )
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          textAlignVertical: TextAlignVertical.center,
                                          controller: controller.todoController,
                                          onTap: controller.onEdit,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '할일 추가 +',
                                              hintStyle: StyledFont.BODY_GRAY,
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 4)),
                                          style: StyledFont.BODY,
                                          textAlign: TextAlign.start,
                                          onFieldSubmitted: (_) => controller.addTodo(),
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                      // Obx(
                                      //   () => controller.hasMember.isFalse
                                      //       ? Container()
                                      //       : WidgetContent(
                                      //           title: '함께하는 사람',
                                      //           content: SizedBox(
                                      //             height: 40,
                                      //             child: Row(
                                      //               crossAxisAlignment: CrossAxisAlignment.center,
                                      //               children: List.generate(
                                      //                 controller.memberList.length + 1,
                                      //                 (index) {
                                      //                   if (index == controller.memberList.length) {
                                      //                     return Container(
                                      //                       constraints: const BoxConstraints(
                                      //                         maxHeight: 40,
                                      //                         maxWidth: 80,
                                      //                       ),
                                      //                       alignment: Alignment.center,
                                      //                       child: TextFormField(
                                      //                         textAlignVertical: TextAlignVertical.center,
                                      //                         controller: controller.memberController,
                                      //                         onTap: controller.onEdit,
                                      //                         decoration: const InputDecoration(
                                      //                             border: InputBorder.none,
                                      //                             hintText: '추가 +',
                                      //                             hintStyle: StyledFont.BODY_GRAY,
                                      //                             isDense: true,
                                      //                             contentPadding: EdgeInsets.symmetric(vertical: 4)),
                                      //                         style: StyledFont.BODY,
                                      //                         textAlign: TextAlign.start,
                                      //                         onFieldSubmitted: (_) => controller.addMember(),
                                      //                         textInputAction: TextInputAction.done,
                                      //                       ),
                                      //                     );
                                      //                   }
                                      //                   return MemberItem(
                                      //                     index,
                                      //                     name: controller.memberList[index],
                                      //                     onTap: () => controller.showMemberInfo(index),
                                      //                   );
                                      //                 },
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      // ),
                                      Obx(
                                            () => controller.hasLocation.isFalse
                                            ? Container()
                                            : TextContent(
                                          textEditingController: controller.locationController,
                                          title: '장소',
                                          hintText: '장소 추가',
                                          maxLines: 1,
                                        ),
                                      ),
                                      Obx(
                                            () => controller.hasDetail.isFalse
                                            ? Container()
                                            : TextContent(
                                          textEditingController: controller.detailController,
                                          title: '상세',
                                          hintText: '상세 내용 추가',
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onVerticalDragStart: (_) => controller.hideKeyboard(),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: controller.addContent,
                                      child: const Text('+ 내용 추가', style: StyledFont.HEADLINE),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    if (!controller.isNew)
                                      TextButton(
                                        onPressed: controller.removeSchedule,
                                        child: const Text('삭제', style: StyledFont.CALLOUT_NEGATIVE),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class TextContent extends GetView<CreateScheduleController> {
  final TextEditingController textEditingController;
  final String title;
  final String hintText;
  final int? maxLines;
  final void Function(String?)? onFieldSubmitted;

  const TextContent({Key? key, required this.textEditingController, required this.title, required this.hintText, this.maxLines, this.onFieldSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: StyledFont.CAPTION_1_GRAY,
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: textEditingController,
            onTap: controller.onEdit,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: StyledFont.BODY_GRAY,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            maxLines: maxLines,
            style: StyledFont.BODY,
            textAlign: TextAlign.start,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: maxLines == null ? TextInputAction.newline : TextInputAction.done,
          )
        ],
      ),
    );
  }
}

class WidgetContent extends StatelessWidget {
  final String title;
  final Widget content;

  const WidgetContent({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: StyledFont.CAPTION_1_GRAY,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: content,
        ),
      ],
    );
  }
}

class TodoItem extends GetView<CreateScheduleController> {
  final Todo todo;
  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          if (todo.todoStatus == TodoStatus.done)
            Image.asset(AssetNames.todoDone, width: 24, height: 24,),
          if (todo.todoStatus == TodoStatus.pass)
            Image.asset(AssetNames.todoPass, width: 24, height: 24,),
          if (todo.todoStatus == TodoStatus.notStarted)
            Image.asset(AssetNames.todoNotStarted, width: 24, height: 24,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(todo.todoTitle, style: StyledFont.BODY),
          ),
        ],
      ),
    );
  }
}
