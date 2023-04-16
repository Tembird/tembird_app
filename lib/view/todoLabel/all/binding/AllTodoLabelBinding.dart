import 'package:get/get.dart';
import 'package:tembird_app/view/todoLabel/all/controller/AllTodoLabelContoller.dart';

class AllTodoLabelBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AllTodoLabelController());
  }
}
