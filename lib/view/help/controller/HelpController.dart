import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class HelpController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static HelpController to = Get.find();

  final RxBool onLoading = RxBool(true);
  final String email = SessionService.to.email;
  final RxString userId = RxString(SessionService.to.userId);
  final RxString appVersion = RxString(SessionService.to.appVersion);

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

  void showAnnouncement() {
    // TODO : Show Announcement Page
  }

  void showTerms() {
    // TODO : Show Terms Page
  }

  void showPrivacyPolicy() {
    // TODO : Show PrivacyPolicy Page
  }

  void contactDeveloper() {
    // TODO : Route to ContactDeveloperView
  }

  // Session
  void signOut() async {
    onLoading.value = true;
    await SessionService.to.quitSession();
    onLoading.value = false;
  }

  void removeAccount() async {
    // TODO : Route to RemoveAccountPage
  }
}