import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class UpdateUsernameController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static UpdateUsernameController to = Get.find();

  final RxBool onLoading = RxBool(false);
  final String currentUsername = SessionService.to.sessionUser.value!.username;
  final TextEditingController usernameController = TextEditingController();
  final RxBool isPossible = RxBool(true);
  final RxnString usernameError = RxnString(null);

  @override
  void onInit() {
    usernameController.text = currentUsername;
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  void back() {
    Get.back();
  }

  Future<void> checkPossibleUsername() async {
    onLoading.value = true;
    try {
      if (usernameController.value.text.isEmpty) {
        isPossible.value = false;
        usernameError.value = '아이디를 입력해주세요';
        return;
      }

      if (usernameController.value.text == currentUsername ) {
        isPossible.value = false;
        usernameError.value = '동일한 아이디로 변경할 수 없니다';
        return;
      }

      isPossible.value = true;
      usernameError.value = null;
    } finally {
      onLoading.value = false;
    }
  }
  
  void updateUsername() async {
    onLoading.value = true;
    try {
      await checkPossibleUsername();
      if (isPossible.isFalse) return;
      onLoading.value = true;
      await authRepository.updateUsername(username: usernameController.value.text);
      await SessionService.to.getSessionUserInfo();
      Get.back(
        result: true
      );
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      onLoading.value = false;
    }
  }
}