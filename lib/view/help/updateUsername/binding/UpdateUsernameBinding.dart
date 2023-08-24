import 'package:get/get.dart';

import '../controller/UpdateUsernameController.dart';

class UpdateUsernameBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(UpdateUsernameController());
  }
}
