import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/model/User.dart';
import 'package:tembird_app/service/FirebaseMessagingService.dart';
import '../constant/PageNames.dart';
import '../repository/AuthRepository.dart';

enum SessionStatus { active, empty }

class SessionService extends GetxService {
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
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

    if (accessToken == null) return;
    await getSessionUserInfo();
    if (sessionUser.value == null) return;
    if (sessionUser.value!.username.startsWith('unknown#')) {
      await Get.toNamed(PageNames.REGISTER_USERNAME);
    }
    updateUserHistory();
    sessionStatus.value = SessionStatus.active;
  }

  Future<void> getSessionUserInfo() async {
    try {
      sessionUser.value = await authRepository.getUserInfo();
    } catch (e) {
      sessionUser.value = null;
    }
  }

  Future<void> updateUserHistory() async {
    await authRepository.updateUserHistory(platform: Platform.operatingSystem, platformVersion: Platform.operatingSystemVersion, buildNum: int.parse(appBuildNum));
  }

  Future<void> quitSession() async {
    await authRepository.signOut();
    await _firebaseMessagingService.deleteFcmToken();
    await Get.offAllNamed(PageNames.INIT);
  }
}
