import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/TodoLabelRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/dialog/color/select/SelectColorDialogView.dart';

import '../../../../constant/StyledFont.dart';
import '../../../../constant/StyledPalette.dart';

class EditTodoLabelController extends RootController {
  final TodoLabelRepository todoLabelRepository = TodoLabelRepository();
  final TodoLabel? initTodoLabel;
  Rxn<TodoLabel> todoLabel = Rxn(null);
  final TextEditingController titleController = TextEditingController();
  final RxString selectedColorHex = RxString(StyledPalette.DEFAULT_COLOR_HEX);

  EditTodoLabelController({required this.initTodoLabel});

  @override
  void onInit() {
    if (initTodoLabel != null) {
      todoLabel.value = initTodoLabel;
      titleController.text = initTodoLabel!.title;
      selectedColorHex.value = initTodoLabel!.colorHex;
    }
    super.onInit();
  }

  void back() {
    Get.back();
  }

  void openColorPalette() async {
    String? selected = await Get.bottomSheet(
      SelectColorDialogView.route(initColorHex: selectedColorHex.value),
    ) as String?;

    if (selected == null) return;

    selectedColorHex.value = selected;
  }

  void save() async {
    if (initTodoLabel != null && initTodoLabel?.title == titleController.value.text && initTodoLabel?.colorHex == selectedColorHex.value) {
      Get.back();
      return;
    }
    if (titleController.value.text.isEmpty) {
      Get.dialog(
        const AlertDialog(
          content: Text(
            '카테고리 제목을 입력해주세요',
            style: StyledFont.FOOTNOTE,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    if (selectedColorHex.value == StyledPalette.DEFAULT_COLOR_HEX) {
      Get.dialog(
        const AlertDialog(
          content: Text(
            '카테고리 색상을 선택해주세요',
            style: StyledFont.FOOTNOTE,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    if (initTodoLabel == null) {
      createTodoLabel();
    } else {
      updateTodoLabel();
    }
  }

  void createTodoLabel() async {
    TodoLabel created = await todoLabelRepository.createTodoLabel(title: titleController.value.text, colorHex: selectedColorHex.value);
    Get.back(
      result: ActionResult(action: ActionResultType.created, todoLabel: created),
    );
  }

  void updateTodoLabel() async {
    TodoLabel todoLabel = TodoLabel(
      id: initTodoLabel!.id,
      title: titleController.value.text,
      colorHex: selectedColorHex.value,
      createdAt: initTodoLabel!.createdAt,
      updatedAt: DateTime.now(),
    );
    TodoLabel updated = await todoLabelRepository.updateTodo(todoLabel: todoLabel);
    Get.back(
      result: ActionResult(action: ActionResultType.updated, todoLabel: updated),
    );
  }
}
