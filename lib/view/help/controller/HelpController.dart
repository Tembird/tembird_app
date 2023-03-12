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
  final String email = SessionService.to.email;
  final RxString userId = RxString(SessionService.to.userId);
  final RxString appVersion = RxString(SessionService.to.appVersion);

  final RxnString announcementData = RxnString(null);
  final RxnString termsData = RxnString(null);
  final RxnString privacyPolicyData = RxnString(null);

  void back() {
    Get.back();
  }

  /// ProfileSetting
  void updateId() {
    // TODO : Route to UpdateIdView
  }

  void updatePassword() {
    // TODO : Route to UpdatePasswordView
  }

  // AppInfo
  void checkRecentVersion() {
    // TODO : Check Recent Version and Alert to Update
  }

  void showAnnouncement() async {
    onLoading.value = true;
    try {
      announcementData.value = await helpRepository.readAnnouncement();
      Get.toNamed(PageNames.HTML, arguments: HtmlViewArguments(title: '공지사항', data: announcementData.value!));
    } finally {
      onLoading.value = false;
    }
  }

  Future<void> showTerms() async {
    onLoading.value = true;
    try {
      termsData.value = await helpRepository.readTerms();
      Get.toNamed(PageNames.HTML, arguments: HtmlViewArguments(title: '서비스 이용약관', data: termsData.value!));
    } finally {
      onLoading.value = false;
    }
  }

  Future<void> showPrivacyPolicy() async {
    onLoading.value = true;
    try {
      privacyPolicyData.value = await helpRepository.readPrivacyPolicy();
      Get.toNamed(PageNames.HTML, arguments: HtmlViewArguments(title: '개인정보 처리방침', data: privacyPolicyData.value!));
    } finally {
      onLoading.value = false;
    }
  }

  void contactDeveloper() {
    // TODO : Route to ContactDeveloperView
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
    // TODO : Route to RemoveAccountPage
  }
}