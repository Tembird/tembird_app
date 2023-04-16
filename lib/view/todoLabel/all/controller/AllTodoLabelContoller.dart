import 'package:get/get.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/repository/TodoLabelRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/todoLabel/edit/EditTodoLabelView.dart';

import '../../../../model/ModalAction.dart';
import '../../../../model/TodoLabel.dart';

class AllTodoLabelController extends RootController {
  final TodoLabelRepository todoLabelRepository = TodoLabelRepository();
  RxList<TodoLabel> todoLabelList = RxList([]);
  RxBool onLoading = RxBool(true);
  bool hasChanged = false;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  void initialize() async {
    await getCategoryList();
  }

  Future<void> getCategoryList() async {
    try {
      todoLabelList.clear();
      List<TodoLabel> list = await todoLabelRepository.readAllTodoLabel();
      todoLabelList.addAll(list);
    } finally {
      onLoading.value = false;
    }
  }

  void editTodoLabel({required int index}) async {
    final List<ModalAction> modalActionList = [
      ModalAction(name: '수정하기', onPressed: () => Get.back(result: 0), isNegative: false),
      ModalAction(name: '삭제하기', onPressed: () => Get.back(result: 1), isNegative: false),
    ];
    int? action = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: '수정 및 삭제',
    );

    if (action == null) return;
    if (action == 0) {
      updateTodoLabel(index: index);
      return;
    }
    if (action == 1) {
      removeTodoLabel(index: index);
      return;
    }
  }

  void removeTodoLabel({required int index}) async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      await todoLabelRepository.deleteTodo(id: todoLabelList[index].id);
      hasChanged = true;
      todoLabelList.removeAt(index);
      todoLabelList.refresh();
    } finally {
      onLoading.value = false;
    }
  }

  void updateTodoLabel({required int index}) async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      ActionResult? actionResult = await Get.toNamed(
        EditTodoLabelView.routeName,
        arguments: todoLabelList[index],
      ) as ActionResult?;

      if (actionResult == null) return;

      if (actionResult.action == ActionResultType.updated) {
        todoLabelList[index] = actionResult.todoLabel!;
        hasChanged = true;
        return;
      }
    } finally {
      onLoading.value = false;
    }
  }

  void createTodoLabel() async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      ActionResult? actionResult = await Get.toNamed(
        EditTodoLabelView.routeName,
        arguments: null,
      ) as ActionResult?;

      if (actionResult == null) return;

      if (actionResult.action == ActionResultType.created) {
        todoLabelList.add(actionResult.todoLabel!);
        hasChanged = true;
        return;
      }
    } finally {
      onLoading.value = false;
    }
  }

  void back() {
    Get.back(result: hasChanged);
  }
}
