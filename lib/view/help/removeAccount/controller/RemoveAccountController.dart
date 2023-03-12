import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/model/ModalAction.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class RemoveAccountController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static RemoveAccountController to = Get.find();

  final RxBool onLoading = RxBool(false);
  final TextEditingController passwordController = TextEditingController();
  final RxnString passwordError = RxnString(null);
  final RxBool isPasswordObscured = RxBool(false);

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void back() {
    Get.back();
  }

  void obscurePassword() {
    isPasswordObscured.value = true;
  }

  void showPassword() {
    isPasswordObscured.value = false;
  }

  void passwordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
      if (!regExp.hasMatch(value)) {
        passwordError.value = '영문, 숫자, 특수문자 포함 8자 이상으로 입력해주세요';
      } else {
        passwordError.value = null;
      }
    } else {
      passwordError.value = '현재 비밀번호를 입력해주세요';
    }
  }

  void removeAccount() async {
    onLoading.value = true;
    try {
      passwordValidator(passwordController.value.text);
      if (passwordError.value != null) return;
      final List<ModalAction> modalActionList = [ModalAction(name: '삭제', onPressed: confirmRemove, isNegative: true)];
      bool? isConfirmed = await showCupertinoActionSheet(
        modalActionList: modalActionList,
        title: '정말 삭제하시겠습니까?',
      ) as bool?;

      if (isConfirmed == null) return;
      await authRepository.removeAccount(
        email: SessionService.to.email,
        password: passwordController.value.text,
      );
      SessionService.to.quitSession();
    } finally {
      onLoading.value = false;
    }
  }

  void confirmRemove() {
    Get.back(result: true);
  }
}
