import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/InputTextFormField.dart';
import '../../../constant/StyledFont.dart';
import '../../../constant/StyledPalette.dart';
import 'controller/ResetPasswordController.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text('비밀번호 초기화', style: StyledFont.LARGE_TITLE),
                SizedBox(height: 16),
                EmailForm(),
                VerificationCodeForm(),
                SizedBox(height: 16),
                PasswordForm(),
                SizedBox(height: 16),
                ConfirmPasswordForm(),
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

class EmailForm extends GetView<ResetPasswordController> {
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
        enabled: controller.isEmailVerified.isFalse,
        suffixWidget: controller.isEmailVerified.isFalse
            ? InkWell(
          onTap: controller.requestVerificationCodeEmail,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: StyledPalette.PRIMARY_BLUE, width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              "인증 번호 받기",
              style: StyledFont.FOOTNOTE_SKY,
            ),
          ),
        )
            : const Text(
          "인증된 이메일",
          style: StyledFont.FOOTNOTE_SKY,
        ),
      ),
    );
  }
}

class VerificationCodeForm extends GetView<ResetPasswordController> {
  const VerificationCodeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.isVerificationEmailSent.isFalse || controller.isEmailVerified.isTrue || controller.emailError.value != null
          ? Container()
          : Padding(
        padding: const EdgeInsets.only(top: 16),
        child: InputTextFormField(
          controller: controller.verificationCodeController,
          errorText: controller.verificationCodeError.value,
          labelText: "인증번호",
          hintText: "인증번호",
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.verificationCodeValidator(value),
          suffixWidget: InkWell(
            onTap: controller.confirmVerificationCode,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: StyledPalette.PRIMARY_BLUE, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                "인증하기",
                style: StyledFont.FOOTNOTE_SKY,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordForm extends GetView<ResetPasswordController> {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.isEmailVerified.isTrue
          ? InputTextFormField(
        controller: controller.passwordController,
        labelText: "비밀번호",
        hintText: "비밀번호",
        errorText: controller.passwordError.value,
        isObscured: controller.isPasswordObscured.isTrue,
        onChanged: (value) => controller.passwordValidator(value),
        keyboardType: TextInputType.visiblePassword,
        suffixWidget: InkWell(
          onTap: controller.isPasswordObscured.isTrue ? controller.showPassword : controller.obscurePassword,
          child: Text(
            controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
            style: StyledFont.CAPTION_1_GRAY,
          ),
        ),
      )
          : Container(),
    );
  }
}

class ConfirmPasswordForm extends GetView<ResetPasswordController> {
  const ConfirmPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.isEmailVerified.isFalse || controller.passwordError.value != null
          ? Container()
          : InputTextFormField(
        controller: controller.passwordConfirmController,
        labelText: "비밀번호 확인",
        hintText: "비밀번호 확인",
        errorText: controller.passwordConfirmError.value,
        isObscured: controller.isPasswordObscured.isTrue,
        onChanged: (value) => controller.passwordConfirmValidator(value),
        keyboardType: TextInputType.visiblePassword,
        suffixWidget: InkWell(
          onTap: controller.isPasswordObscured.isTrue ? controller.showPassword : controller.obscurePassword,
          child: Text(
            controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
            style: StyledFont.CAPTION_1_GRAY,
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends GetView<ResetPasswordController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.updatePassword,
      radius: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: StyledPalette.PRIMARY_BLUE,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '완료',
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}