import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/dialog/todo/detail/argument/DetailTodoDialogArgument.dart';
import 'package:tembird_app/view/dialog/todo/detail/controller/DetailTodoDialogController.dart';

import '../../../../constant/StyledFont.dart';

class DetailTodoDialogView extends GetView<DetailTodoDialogController> {
  const DetailTodoDialogView({Key? key}) : super(key: key);

  static route({required DetailTodoDialogArgument argument}) {
    return GetBuilder(
      init: DetailTodoDialogController(argument: argument),
      builder: (_) => const DetailTodoDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyledPalette.TRANSPARENT,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(controller.dateToString(date: controller.argument.date), style: StyledFont.TITLE_2_WHITE,),
          const SizedBox(height: 16),
          Material(
            borderRadius: BorderRadius.circular(16),
            color: StyledPalette.MINERAL,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              constraints: BoxConstraints(maxHeight: Get.height / 2),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      controller.argument.todoLabel.title,
                      style: StyledFont.FOOTNOTE.copyWith(color: controller.hexToColor(colorHex: controller.argument.todoLabel.colorHex)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.argument.todo.title,
                      style: StyledFont.TITLE_3_700,
                    ),
                    const Divider(
                      height: 16,
                      thickness: 0.5,
                    ),
                    if (controller.argument.todo.startAt != null && controller.argument.todo.endAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.access_time_outlined,
                              size: 12,
                              color: StyledPalette.GRAY,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '일시',
                              style: StyledFont.FOOTNOTE_GRAY,
                            ),
                          ],
                        ),
                      ),
                    if (controller.argument.todo.startAt != null && controller.argument.todo.endAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${controller.indexToTimeString(index: controller.argument.todo.startAt!)} ~ ${controller.indexToTimeString(index: controller.argument.todo.endAt!)}',
                          style: StyledFont.BODY,
                        ),
                      ),
                    if (controller.argument.todo.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: StyledPalette.GRAY,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '장소',
                              style: StyledFont.FOOTNOTE_GRAY,
                            ),
                          ],
                        ),
                      ),
                    if (controller.argument.todo.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          controller.argument.todo.location!,
                          style: StyledFont.BODY,
                        ),
                      ),
                    if (controller.argument.todo.detail != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.article_outlined,
                              size: 12,
                              color: StyledPalette.GRAY,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '상세 내용',
                              style: StyledFont.FOOTNOTE_GRAY,
                            ),
                          ],
                        ),
                      ),
                    if (controller.argument.todo.detail != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          controller.argument.todo.detail!,
                          style: StyledFont.BODY,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.back(result: true),
            child: const Icon(Icons.settings, size: 24, color: StyledPalette.GRAY),
          )
        ],
      ),
    );
  }
}
