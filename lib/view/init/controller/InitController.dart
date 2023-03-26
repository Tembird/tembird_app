import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/Update.dart';
import 'package:tembird_app/repository/InitRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constant/Common.dart';
import '../../../constant/PageNames.dart';
import '../../../service/SessionService.dart';

class InitController extends RootController {
  final InitRepository initRepository = InitRepository();
  static InitController to = Get.find();
  final RxBool onLoading = RxBool(true);
  int appBuildNum = 0;
  int recentUpdateBuildNum = 0;

  @override
  onInit() async {
    super.onInit();
    onLoading.value = true;
    await checkUpdatedVersion();
    await SessionService.to.initSession();
    await Future.delayed(const Duration(milliseconds: 1000));
    routeAccordingToSessionUserStatus();
  }

  Future<void> checkUpdatedVersion() async {
    try {
      final Update update = await initRepository.readUpdateInfo();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appBuildNum = int.parse(packageInfo.buildNumber);

      if (update.buildNum <= appBuildNum) return;
      if (!update.isNecessary && !update.onMaintainance) {
        bool isUpdateAlertBlocked = await checkUpdateAlertBlocked(updateId: update.id);
        if (isUpdateAlertBlocked) return;
      }
      return Get.dialog(
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    children: [
                      Text(update.onMaintainance ? '점검 알림' : '업데이트 알림', style: StyledFont.HEADLINE),
                      const SizedBox(height: 16),
                      Text(update.reason, style: StyledFont.CALLOUT),
                      const SizedBox(height: 16),
                      if (!update.onMaintainance)
                        GestureDetector(
                          onTap: routeStoreToUpdate,
                          child: Container(
                              decoration: BoxDecoration(
                                color: StyledPalette.STATUS_INFO,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              child: const Text('지금 업데이트', style: StyledFont.CALLOUT_WHITE)),
                        )
                    ],
                  ),
                ),
              ),
              if (!update.isNecessary && !update.onMaintainance)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => blockUpdateAlert(updateId: update.id),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('더 이상 안볼래요', style: StyledFont.CALLOUT_GRAY),
                      ),
                    ),
                    GestureDetector(
                      onTap: Get.back,
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('다음에 할게요', style: StyledFont.CALLOUT_GRAY),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        barrierDismissible: !update.isNecessary && !update.onMaintainance,
      );
    } catch (e) {
      print(e);
      return Get.dialog(
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text('서비스 오류', style: StyledFont.HEADLINE, textAlign: TextAlign.center),
                      SizedBox(height: 16),
                      Text('현재 앱을 실행할 수 없다면\n아래 방법을 시도해주세요', style: StyledFont.CALLOUT),
                      SizedBox(height: 16),
                      Text('1. 네트워크 상태 확인', style: StyledFont.CALLOUT_700),
                      Text('네트워크 상태가 고르지 않으면 저장된 일정을 불러오지 못해 서비스를 이용할 수 없어요', style: StyledFont.FOOTNOTE),
                      SizedBox(height: 8),
                      Text('2. 앱을 완전히 삭제 후 최신 버전 재설치', style: StyledFont.CALLOUT_700),
                      Text('오류 발생 시 빠른 업데이트를 통해 사용자가 불편을 느끼지 않도록 최선을 다하고 있어요', style: StyledFont.FOOTNOTE),
                      SizedBox(height: 8),
                      Text('3. Tembird 팀에 문의', style: StyledFont.CALLOUT_700),
                      Text('저희에게 겪고 계신 문제를 말씀해주시면 사용에 불편이 없도록 빠르게 처리해드릴게요', style: StyledFont.FOOTNOTE),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void routeStoreToUpdate() async {
    if (GetPlatform.isAndroid) {
      const String url = 'https://play.google.com/store/apps';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      }
    }
    if (GetPlatform.isIOS) {
      const String url = 'https://apps.apple.com/kr';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  void blockUpdateAlert({required int updateId}) async {
    await Hive.box(Common.session).delete(Common.blockedUpdateAlert);
    await Hive.box(Common.session).put(Common.blockedUpdateAlert, updateId);
    Get.back();
  }

  Future<bool> checkUpdateAlertBlocked({required int updateId}) async {
    int? blockedUpdateId = await Hive.box(Common.session).get(Common.blockedUpdateAlert);
    if (blockedUpdateId == null) return false;
    return blockedUpdateId == updateId;
  }

  void routeAccordingToSessionUserStatus() {
    switch (SessionService.to.sessionStatus.value) {
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
