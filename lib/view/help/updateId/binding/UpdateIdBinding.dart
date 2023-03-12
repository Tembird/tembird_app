import 'package:get/get.dart';
import 'package:tembird_app/view/help/updateId/controller/UpdateIdController.dart';

class UpdateIdBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UpdateIdController());
  }
}
