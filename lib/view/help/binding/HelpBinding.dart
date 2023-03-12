import 'package:get/get.dart';
import 'package:tembird_app/view/help/controller/HelpController.dart';

class HelpBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HelpController());
  }
}
