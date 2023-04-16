import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/todoLabel/edit/controller/EditTodoLabelController.dart';

import '../../../constant/StyledFont.dart';

class EditTodoLabelView extends GetView<EditTodoLabelController> {
  static String routeName = '/todoLabel/edit';

  const EditTodoLabelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(controller.initTodoLabel == null ? '카테고리 등록' : '카테고리 편집'),
        leading: BackButton(
          color: StyledPalette.BLACK,
          onPressed: controller.back,
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: controller.save,
              child: const Text('저장', style: StyledFont.CALLOUT_INFO),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('색상', style: StyledFont.CALLOUT_700),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: controller.openColorPalette,
                    child: Container(
                      decoration: BoxDecoration(
                        color: StyledPalette.WHITE,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: StyledPalette.BLACK10,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Obx(
                        () => CircleAvatar(
                          radius: 12,
                          backgroundColor: controller.hexToColor(colorHex: controller.selectedColorHex.value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('제목', style: StyledFont.CALLOUT_700),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      controller: controller.titleController,
                      style: StyledFont.HEADLINE,
                      decoration: const InputDecoration(
                        hintText: '제목',
                        hintStyle: StyledFont.BODY_GRAY,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
