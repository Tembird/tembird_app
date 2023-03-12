import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/PageNames.dart';
import '../../../../repository/AuthRepository.dart';

class LoginController extends GetxController {
  static LoginController to = Get.find();
  final AuthRepository authRepository = AuthRepository();

  final RxBool onLoading = RxBool(false);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxnString emailError = RxnString(null);
  final RxnString passwordError = RxnString(null);
  final RxBool isPasswordObscured = RxBool(true);

  void onPasswordObscure() {
    isPasswordObscured.value = true;
  }

  void offPasswordObscure() {
    isPasswordObscured.value = false;
  }

  void emailValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      RegExp regExp = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regExp.hasMatch(value)) {
        emailError.value = '올바른 이메일을 입력해주세요';
      } else {
        emailError.value = null;
      }
    } else {
      emailError.value = '이메일을 입력해주세요';
    }
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
      passwordError.value = '비밀번호를 입력해주세요';
    }
  }

  void login() async {
    onLoading.value = true;
    try {
      emailValidator(emailController.value.text);
      passwordValidator(passwordController.value.text);
      if (emailError.value != null || passwordError.value != null) return;
      await authRepository.login(email: emailController.value.text, password: passwordController.value.text);
      Get.offAllNamed(PageNames.HOME);
    } finally {
      onLoading.value = false;
    }
  }

  void routeResetPasswordView() {
    Get.toNamed(PageNames.RESET_PASSWORD);
  }

  void back() {
    Get.back();
  }
}
