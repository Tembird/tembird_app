import 'package:get/get.dart';
import 'package:tembird_app/constant/PageNames.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/repository/HelpRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';
import 'package:tembird_app/view/common/HtmlView.dart';

class HelpController extends RootController {
  final HelpRepository helpRepository = HelpRepository();
  final AuthRepository authRepository = AuthRepository();
  static HelpController to = Get.find();

  final RxBool onLoading = RxBool(true);
  final String email = SessionService.to.sessionUser.value!.email;
  final String appVersion = '${SessionService.to.appVersion} (${SessionService.to.appBuildNum})';
  final RxString username = RxString(SessionService.to.sessionUser.value!.username);

  final RxnString announcementData = RxnString(null);
  final RxnString termsData = RxnString(null);
  final RxnString privacyPolicyData = RxnString(null);

  void back() {
    Get.back();
  }

  /// ProfileSetting
  void updateUsername() async {
    bool? isUpdated = await Get.toNamed(PageNames.UPDATE_USERNAME) as bool?;

    if (isUpdated == null) return;
    username.value = SessionService.to.sessionUser.value!.username;
  }

  void updatePassword() async {
    await Get.toNamed(PageNames.UPDATE_PASSWORD);
  }

  // AppInfo
  void checkRecentVersion() {
    // TODO : Check Recent Version and Alert to Update
  }

  void showAnnouncement() async {
    Get.toNamed(PageNames.ANNOUNCEMENT);
  }

  Future<void> showTerms() async {
    onLoading.value = true;
    try {
      termsData.value = await helpRepository.readTerms();
      await Get.toNamed(PageNames.HTML, arguments: HtmlViewArguments(title: '서비스 이용약관', data: termsData.value!));
      termsData.value = null;
    } finally {
      onLoading.value = false;
    }
  }

  Future<void> showPrivacyPolicy() async {
    onLoading.value = true;
    try {
      privacyPolicyData.value = await helpRepository.readPrivacyPolicy();
      await Get.toNamed(PageNames.HTML, arguments: HtmlViewArguments(title: '개인정보 처리방침', data: privacyPolicyData.value!));
      privacyPolicyData.value = null;
    } finally {
      onLoading.value = false;
    }
  }

  void contact() {
    Get.toNamed(PageNames.CONTACT);
  }

  // Session
  void signOut() async {
    onLoading.value = true;
    try {
      await SessionService.to.quitSession();
    } finally {
      onLoading.value = false;
    }
  }

  void removeAccount() async {
    Get.toNamed(PageNames.REMOVE_ACCOUNT);
  }
}