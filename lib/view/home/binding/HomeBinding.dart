import 'package:get/get.dart';
import '../../../service/FirebaseMessagingService.dart';
import '../controller/HomeController.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(FirebaseMessagingService());
    Get.put(HomeController());
  }
}
