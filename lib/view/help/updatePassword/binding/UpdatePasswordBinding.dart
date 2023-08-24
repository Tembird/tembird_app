import 'package:get/get.dart';
import '../controller/UpdatePasswordController.dart';

class UpdatePasswordBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UpdatePasswordController());
  }
}
