import 'package:get/get.dart';
import 'package:tembird_app/view/todoLabel/edit/controller/EditTodoLabelController.dart';

import '../../../../model/TodoLabel.dart';

class EditTodoLabelBinding extends Bindings {
  @override
  void dependencies() {
    final TodoLabel? todoLabel = Get.arguments;
    Get.put(EditTodoLabelController(initTodoLabel: todoLabel));
  }
}