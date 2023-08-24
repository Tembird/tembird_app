import 'package:get/get.dart';

import '../controller/SignupController.dart';

class SignupBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SignupController());
  }
}
