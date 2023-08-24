import 'package:get/get.dart';
import 'package:tembird_app/service/SessionService.dart';

import '../controller/InitController.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SessionService());
    Get.put(InitController());
  }
}