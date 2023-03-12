import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/AuthRepository.dart';

import '../../../../constant/PageNames.dart';

enum SignupProcess { email, verificationCode, password, id }

class SignupController extends GetxController {
  static SignupController to = Get.find();

  final AuthRepository authRepository = AuthRepository();
  final RxBool onLoading = RxBool(false);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  final RxnString emailError = RxnString('이메일을 입력해주세요');
  final RxBool isVerificationEmailSent = RxBool(false);
  final RxnString verificationCodeError = RxnString('6자리 인증 코드를 입력하세요');
  final RxBool isEmailVerified = RxBool(false);

  final RxnString passwordError = RxnString('영문, 숫자, 특수문자 포함 8자 이상으로 비밀번호를 입력해주세요');
  final RxnString passwordConfirmError = RxnString('다시 한번 비밀번호를 입력해주세요');
  final RxBool isPasswordObscured = RxBool(true);

  void emailValidator(String? value) {
    isEmailVerified.value = false;
    isVerificationEmailSent.value = false;
    if (value != null && value.isNotEmpty) {
      RegExp regExp =
          RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regExp.hasMatch(value)) {
        emailError.value = '올바른 이메일을 입력해주세요';
      } else {
        emailError.value = null;
      }
    } else {
      emailError.value = '이메일을 입력해주세요';
    }
  }

  void requestVerificationCodeEmail() async {
    onLoading.value = true;
    try {
      emailValidator(emailController.value.text);
      if (emailError.value != null) return;
      await authRepository.sendVerificationEmail(email: emailController.value.text);
      isVerificationEmailSent.value = true;
    } finally {
      onLoading.value = false;
    }
  }

  void verificationCodeValidator(String? value) {
    if (value == null || value.length != 6) return;
    verificationCodeError.value = null;
  }

  void confirmVerificationCode() async {
    onLoading.value = true;
    try {
      verificationCodeValidator(verificationCodeController.value.text);
      if (verificationCodeError.value != null) return;

      isEmailVerified.value = false;

      bool isVerified = await authRepository.checkVerificationCode(
        email: emailController.value.text,
        code: verificationCodeController.value.text,
      );
      if (!isVerified) return;
      isEmailVerified.value = true;
    } finally {
      onLoading.value = false;
    }
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
      passwordError.value = '비밀번호를 입력해주세요';
      passwordConfirmValidator(passwordConfirmController.value.text);
    }
  }

  void passwordConfirmValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value != passwordController.value.text) {
        passwordConfirmError.value = '비밀번호가 일치하지 않습니다';
      } else {
        passwordConfirmError.value = null;
      }
    } else {
      passwordConfirmError.value = '비밀번호 확인을 입력해주세요';
    }
  }

  void signup() async {
    onLoading.value = true;
    try {
      if (isEmailVerified.isFalse) {
        emailValidator(emailController.value.text);
        return;
      }
      ;
      passwordValidator(passwordController.value.text);
      passwordConfirmValidator(passwordConfirmController.value.text);
      if (passwordError.value != null || passwordConfirmError.value != null) return;

      await authRepository.signup(
        email: emailController.value.text,
        password: passwordController.value.text,
      );
      Get.offAllNamed(PageNames.INIT);
    } finally {
      onLoading.value = false;
    }
  }
}
