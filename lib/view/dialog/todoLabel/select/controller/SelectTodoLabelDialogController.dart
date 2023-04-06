import 'dart:developer';

import 'package:get/get.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/TodoLabelRepository.dart';
import 'package:tembird_app/service/RootController.dart';

class SelectTodoLabelDialogController extends RootController {
  static SelectTodoLabelDialogController to = Get.find();
  SelectTodoLabelDialogController();

  final TodoLabelRepository todoLabelRepository = TodoLabelRepository();

  final RxList<TodoLabel> todoLabelList = RxList([]);
  final RxBool onLoading = RxBool(false);
  @override
  void onInit() async {
    await getTodoLabelList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getTodoLabelList() async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      todoLabelList.clear();
      todoLabelList.value = await todoLabelRepository.readAllTodoLabel();
    } catch (e) {
      log(e.toString());
    } finally {
      todoLabelList.refresh();
      onLoading.value = false;
    }
  }

  void routeTodoLabelListView() async {
    // TODO : 카테고리 목록 페이지로 이동
  }

  void selectTodoLabel({required int index}) async {
    Get.back(result: todoLabelList[index]);
  }
}
