import 'package:get/get.dart';

import '../controller/HelpController.dart';

class HelpBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HelpController());
  }
}
