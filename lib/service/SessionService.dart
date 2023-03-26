import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/model/User.dart';
import '../constant/PageNames.dart';
import '../repository/AuthRepository.dart';

enum SessionStatus { active, empty }

class SessionService extends GetxService {
  static SessionService to = Get.find();
  String appVersion = '';
  String appBuildNum = '';

  final AuthRepository authRepository = AuthRepository();
  final Rx<SessionStatus> sessionStatus = Rx(SessionStatus.empty);
  final Rxn<User> sessionUser = Rxn(null);

  Future<void> initSession() async {
    String? accessToken = Hive.box(Common.session).get(Common.accessTokenHeader, defaultValue: null);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appBuildNum = packageInfo.buildNumber;

    if (accessToken == null) {
      sessionStatus.value = SessionStatus.empty;
      return;
    }
    await getSessionUserInfo();
    sessionStatus.value = SessionStatus.active;
  }

  Future<void> getSessionUserInfo() async {
    sessionUser.value = await authRepository.getUserInfo();
  }

  Future<void> quitSession() async {
    await authRepository.signOut();
    await Get.offAllNamed(PageNames.INIT);
    // TODO : Test Error Exist
    Get.reset();
  }
}
