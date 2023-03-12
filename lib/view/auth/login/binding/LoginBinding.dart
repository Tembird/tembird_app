import 'package:get/get.dart';
import '../controller/LoginController.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
  }
}
