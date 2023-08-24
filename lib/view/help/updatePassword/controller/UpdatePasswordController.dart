import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';

class UpdatePasswordController extends RootController {
  final AuthRepository authRepository = AuthRepository();
  static UpdatePasswordController to = Get.find();

  final RxBool onLoading = RxBool(false);
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordConfirmController = TextEditingController();

  final RxnString currentPasswordError = RxnString(null);
  final RxnString newPasswordError = RxnString(null);
  final RxnString newPasswordConfirmError = RxnString(null);

  final RxBool isPasswordObscured = RxBool(true);

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmController.dispose();
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

  void currentPasswordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
      if (!regExp.hasMatch(value)) {
        currentPasswordError.value = '영문, 숫자, 특수문자 포함 8자 이상으로 입력해주세요';
      } else {
        currentPasswordError.value = null;
      }
    } else {
      currentPasswordError.value = '현재 비밀번호를 입력해주세요';
    }
  }

  void newPasswordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
      if (!regExp.hasMatch(value)) {
        newPasswordError.value = '영문, 숫자, 특수문자 포함 8자 이상으로 입력해주세요';
      } else {
        newPasswordError.value = null;
      }
    } else {
      newPasswordError.value = '새로운 비밀번호를 입력해주세요';
    }
  }

  void newPasswordConfirmValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value != newPasswordController.value.text) {
        newPasswordConfirmError.value = '새로운 비밀번호가 일치하지 않습니다';
      } else {
        newPasswordConfirmError.value = null;
      }
    } else {
      newPasswordConfirmError.value = '새로운 비밀번호 확인을 입력해주세요';
    }
  }
  
  void updatePassword() async {
    onLoading.value = true;
    try {
      currentPasswordValidator(currentPasswordController.value.text);
      newPasswordValidator(newPasswordController.value.text);
      newPasswordConfirmValidator(newPasswordConfirmController.value.text);
      if (currentPasswordError.value != null || newPasswordError.value != null || newPasswordConfirmError.value != null) return;
      await authRepository.updatePasswordWithCurrentPassword(
        currentPassword: currentPasswordController.value.text,
        newPassword: newPasswordController.value.text,
      );
      Get.back();
    } finally {
      onLoading.value = false;
    }
  }
}