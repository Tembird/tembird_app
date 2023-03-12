import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';
import '../constant/PageNames.dart';
import '../repository/AuthRepository.dart';

enum SessionStatus { active, empty }

class SessionService extends GetxService {
  static SessionService to = Get.find();
  // TODO : Save UserInfo
  String email = 'rjsgy0815@naver.com';
  final RxString userId = RxString('Tembird');
  String appVersion = '1.0.0';

  final AuthRepository authRepository = AuthRepository();
  final Rx<SessionStatus> sessionStatus = Rx(SessionStatus.empty);

  Future<void> initSession() async {
    String? accessToken = Hive.box(Common.session).get(Common.accessTokenHeader, defaultValue: null);

    if (accessToken == null) {
      sessionStatus.value = SessionStatus.empty;
      return;
    }
    sessionStatus.value = SessionStatus.active;
  }

  Future<void> updateUserInfo() async {
    // TODO : Update UserInfo from DB
  }

  Future<void> quitSession() async {
    await authRepository.signOut();
    await Get.offAllNamed(PageNames.INIT);
    Get.reset();
  }
}
