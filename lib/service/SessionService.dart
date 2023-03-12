import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';
import '../constant/PageNames.dart';
import '../repository/AuthRepository.dart';

enum SessionStatus { active, empty }

class SessionService extends GetxService {
  static SessionService to = Get.find();

  // final AuthRepository authRepository = AuthRepository();
  final Rx<SessionStatus> sessionStatus = Rx(SessionStatus.empty);

  Future<void> initSession() async {
    String? accessToken = Hive.box(Common.session).get(Common.accessTokenHeader, defaultValue: null);

    if (accessToken == null) {
      sessionStatus.value = SessionStatus.empty;
      return;
    }
    sessionStatus.value = SessionStatus.active;
  }

  // Future<void> quitSession() async {
  //   await authRepository.signOut();
  //   await Get.offAllNamed(PageNames.INIT);
  //   Get.reset();
  // }
}
