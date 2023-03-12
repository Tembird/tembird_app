import 'package:get/get.dart';
import 'package:tembird_app/service/RootController.dart';

import '../../../constant/PageNames.dart';
import '../../../service/SessionService.dart';

class InitController extends RootController {
  static InitController to = Get.find();
  final RxBool onLoading = RxBool(true);

  @override
  onInit() async {
    super.onInit();
    onLoading.value = true;
    await SessionService.to.initSession();
    routeAccordingToSessionUserStatus();
  }

  void routeAccordingToSessionUserStatus() {
    switch(SessionService.to.sessionStatus.value) {
      case SessionStatus.active:
        Get.offAllNamed(PageNames.HOME);
        onLoading.value = false;
        return;
      case SessionStatus.empty:
        onLoading.value = false;
        return;
    }
  }

  void showTerms() {
    // TODO : Show Term Page
  }

  void showPrivacyPolicy() {
    // TODO : Show PrivacyPolicy Page
  }

  void routeLogin() {
    Get.toNamed(PageNames.LOGIN);
  }

  void routeSignUp() {
    Get.toNamed(PageNames.SIGN_UP);
  }
}