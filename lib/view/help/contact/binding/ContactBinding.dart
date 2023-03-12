import 'package:get/get.dart';
import '../controller/ContactController.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ContactController());
  }
}
