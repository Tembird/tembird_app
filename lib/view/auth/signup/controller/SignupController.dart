import 'dart:async';

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

  final RxnString emailError = RxnString(null);
  final RxBool isVerificationEmailSent = RxBool(false);
  final RxBool isVerificationCodeValid = RxBool(false);
  final RxBool isEmailVerified = RxBool(false);

  final RxnString passwordError = RxnString(null);
  final RxnString passwordConfirmError = RxnString(null);
  final RxBool isPasswordObscured = RxBool(true);

  Timer? timer;
  final RxnInt expiredIn = RxnInt(null);

  @override
  void onClose() {
    cancelTimer();
    super.onClose();
  }

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
    if (onLoading.isTrue) return;
    onLoading.value = true;
    try {
      emailValidator(emailController.value.text);
      if (emailError.value != null) return;
      isVerificationEmailSent.value = true;
      setTimer();
      await authRepository.requestVerificationEmail(email: emailController.value.text);
      authRepository.showAlertSnackbar(message: '이메일로 인증 번호가 발송되었습니다');
    } catch(e) {
      isVerificationEmailSent.value = false;
    } finally {
      onLoading.value = false;
    }
  }

  void setTimer() {
    cancelTimer();
    expiredIn.value = 599;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (expiredIn.value! == 0) {
        cancelTimer();
        isVerificationEmailSent.value = false;
        return;
      }
      expiredIn.value = expiredIn.value! - 1;
    });
  }

  void cancelTimer() {
    expiredIn.value = null;
    timer?.cancel();
    timer = null;
  }

  void verificationCodeValidator(String? value) {
    if (value == null || value.length != 6) {
      isVerificationCodeValid.value = false;
      return;
    }
    isVerificationCodeValid.value = true;
  }

  void confirmVerificationCode() async {
    if (onLoading.isTrue) return;
    onLoading.value = true;
    try {
      isEmailVerified.value = false;
      verificationCodeValidator(verificationCodeController.value.text);
      if (isVerificationCodeValid.isFalse) return;

      await authRepository.checkVerificationCode(
        email: emailController.value.text,
        code: verificationCodeController.value.text,
      );
      cancelTimer();
      authRepository.showAlertSnackbar(message: '이메일 인증이 완료되었습니다');
      isEmailVerified.value = true;
    } catch (e) {
      isEmailVerified.value = false;
    }
    finally {
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
    if (onLoading.isTrue) return;
    onLoading.value = true;
    try {
      if (isEmailVerified.isFalse) {
        emailValidator(emailController.value.text);
        return;
      }
      passwordValidator(passwordController.value.text);
      passwordConfirmValidator(passwordConfirmController.value.text);
      if (passwordError.value != null || passwordConfirmError.value != null) return;

      await authRepository.signup(
        email: emailController.value.text,
        password: passwordController.value.text,
      );
      authRepository.showAlertSnackbar(message: '계정 등록이 완료되었습니다!');
      Get.offAllNamed(PageNames.INIT);
    } finally {
      onLoading.value = false;
    }
  }
}
