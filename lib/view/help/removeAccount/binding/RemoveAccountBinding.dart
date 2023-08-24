import 'package:get/get.dart';
import '../controller/RemoveAccountController.dart';

class RemoveAccountBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RemoveAccountController());
  }
}
