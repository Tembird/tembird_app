import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/component/FloatingBannerAdComponent.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/view/dialog/todo/edit/controller/EditTodoDialogController.dart';

import '../../../../constant/StyledFont.dart';

class EditTodoDialogView extends GetView<EditTodoDialogController> {
  const EditTodoDialogView({Key? key}) : super(key: key);

  static route({required bool isNew, required DailyTodoLabel initDailyTodoLabel, DailyTodo? initDailyTodo}) {
    return GetBuilder(
      init: EditTodoDialogController(isNew: isNew, initDailyTodoLabel: initDailyTodoLabel, bannerAdWidth: Get.width, initDailyTodo: initDailyTodo),
      builder: (_) => const EditTodoDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) => controller.bottomSheetVerticalDragStart(details.globalPosition.dy),
      onVerticalDragCancel: controller.bottomSheetVerticalDragCancel,
      onVerticalDragUpdate: (DragUpdateDetails details) => controller.bottomSheetVerticalDragUpdate(details.globalPosition.dy),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: GestureDetector(
                onTap: controller.close,
              ),
            ),
            Obx(() => controller.bannerAd.value == null ? const SizedBox(height: 66) : FloatingBannerAdComponent(bannerAd: controller.bannerAd.value!)),
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
                        children: [
                          Text(controller.isNew ? '할일 추가' : '할일 수정', style: StyledFont.CALLOUT_700),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: controller.onConfirm,
                            child: const Text('완료', style: StyledFont.CALLOUT_INFO),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: StyledPalette.BLACK10,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: controller.isNew ? controller.editDailyTodoLabel : null,
                              child: Obx(
                                () => Text(
                                  controller.dailyTodoLabel.value!.title,
                                  style: StyledFont.HEADLINE.copyWith(color: controller.hexToColor(colorHex: controller.dailyTodoLabel.value!.colorHex)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                autofocus: true,
                                controller: controller.titleController,
                                style: StyledFont.BODY,
                                decoration: const InputDecoration(
                                  hintText: '제목',
                                  hintStyle: StyledFont.BODY_GRAY,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Expanded(
                        child: TodoInputForm(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: controller.addContent,
                              child: const Text('+ 내용 추가', style: StyledFont.HEADLINE),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.delete,
                            child: const Text('삭제', style: StyledFont.CALLOUT_NEGATIVE),
                          ),
                        ],
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
    );
  }
}

class TodoInputForm extends GetView<EditTodoDialogController> {
  const TodoInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
      ),
    );
  }
}

class TextContent extends GetView<EditTodoDialogController> {
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
            scrollPhysics: const NeverScrollableScrollPhysics(),
            controller: textEditingController,
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
