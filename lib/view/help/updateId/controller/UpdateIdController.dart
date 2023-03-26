import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class UpdateIdController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static UpdateIdController to = Get.find();

  final RxBool onLoading = RxBool(false);
  final String currentUserID = SessionService.to.sessionUser.value!.username;
  final TextEditingController userIdController = TextEditingController();
  final RxBool isPossible = RxBool(true);
  final RxnString userIdError = RxnString(null);

  @override
  void onInit() {
    userIdController.text = currentUserID;
    super.onInit();
  }

  @override
  void onClose() {
    userIdController.dispose();
    super.onClose();
  }

  void back() {
    Get.back();
  }

  Future<void> checkPossibleId() async {
    onLoading.value = true;
    try {
      if (userIdController.value.text.isEmpty) {
        isPossible.value = false;
        userIdError.value = '아이디를 입력해주세요';
        return;
      }

      if (userIdController.value.text == currentUserID ) {
        isPossible.value = false;
        userIdError.value = '동일한 아이디로 변경할 수 없니다';
        return;
      }

      isPossible.value = true;
      userIdError.value = null;
    } finally {
      onLoading.value = false;
    }
  }
  
  void updateId() async {
    onLoading.value = true;
    try {
      await checkPossibleId();
      if (isPossible.isFalse) return;
      onLoading.value = true;
      await authRepository.updateId(userId: userIdController.value.text);
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