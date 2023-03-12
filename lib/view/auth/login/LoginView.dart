import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/InputTextFormField.dart';
import '../../../constant/StyledFont.dart';
import '../../../constant/StyledPalette.dart';
import 'controller/LoginController.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: controller.back,
          color: StyledPalette.BLACK,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text('로그인', style: StyledFont.LARGE_TITLE),
                SizedBox(height: 16),
                EmailForm(),
                SizedBox(height: 16),
                PasswordForm(),
                SizedBox(height: 16),
                ResetPassword(),
                SizedBox(height: 16),
                SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailForm extends GetView<LoginController> {
  const EmailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InputTextFormField(
        controller: controller.emailController,
        errorText: controller.emailError.value,
        labelText: "이메일",
        hintText: "이메일",
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => controller.emailValidator(value),
      ),
    );
  }
}

class PasswordForm extends GetView<LoginController> {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InputTextFormField(
        controller: controller.passwordController,
        labelText: "비밀번호",
        hintText: "비밀번호",
        errorText: controller.passwordError.value,
        isObscured: controller.isPasswordObscured.isTrue,
        onChanged: (value) => controller.passwordValidator(value),
        keyboardType: TextInputType.visiblePassword,
        suffixWidget: InkWell(
          onTap: controller.isPasswordObscured.isTrue ? controller.offPasswordObscure : controller.onPasswordObscure,
          child: Text(
            controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
            style: StyledFont.CAPTION_1_GRAY,
          ),
        ),
      ),
    );
  }
}

class ResetPassword extends GetView<LoginController> {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.routeResetPasswordView,
      child: const Text(
        "비밀번호를 잊으셨나요?",
        style: StyledFont.FOOTNOTE_GRAY,
      ),
    );
  }
}

class SubmitButton extends GetView<LoginController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.login,
      radius: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: StyledPalette.PRIMARY_SKY_DARK,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '완료',
            style: StyledFont.TITLE_2_700_WHITE,
          ),
        ),
      ),
    );
  }
}
