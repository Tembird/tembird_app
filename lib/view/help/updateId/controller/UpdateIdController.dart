import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class UpdateIdController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static UpdateIdController to = Get.find();

  final RxBool onLoading = RxBool(false);
  final String currentUserID = SessionService.to.userId.value;
  final TextEditingController userIdController = TextEditingController();
  final RxBool isPossible = RxBool(true);
  final RxnString userIdError = RxnString(null);

  @override
  void onInit() {
    userIdController.text = currentUserID;
    super.onInit();
  }

  void back() {
    Get.back();
  }

  void checkPossibleId() async {
    onLoading.value = true;
    try {

      if (userIdController.value.text.isEmpty || userIdController.value.text == currentUserID ) {
        isPossible.value = false;
        userIdError.value = '현재 사용중인 아이디입니다';
        return;
      }
      bool isPossibleId = await authRepository.checkPossibleId(userId: userIdController.value.text);

      if (!isPossibleId) {
        isPossible.value = false;
        userIdError.value = '이미 존재하는 아이디입니다';
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
      if (userIdController.value.text.isEmpty || userIdController.value.text == currentUserID ) return;
      await authRepository.updateId(userId: userIdController.value.text);
      SessionService.to.updateUserInfo();
      Get.back(
        result: true
      );
    } finally {
      onLoading.value = false;
    }
  }
}