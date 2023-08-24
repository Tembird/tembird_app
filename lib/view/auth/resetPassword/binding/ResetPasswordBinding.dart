import 'package:get/get.dart';

import '../controller/ResetPasswordController.dart';

class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ResetPasswordController());
  }}