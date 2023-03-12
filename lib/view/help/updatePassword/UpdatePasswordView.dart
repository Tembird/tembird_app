import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/component/InputTextFormField.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/help/updateId/controller/UpdateIdController.dart';

import 'controller/UpdatePasswordController.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경', style: StyledFont.TITLE_2),
        leading: BackButton(
          onPressed: controller.back,
          color: StyledPalette.BLACK,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('현재 비밀번호를 입력해주세요', style: StyledFont.BODY,),
                const SizedBox(height: 16),
                Obx(
                  () => InputTextFormField(
                    controller: controller.currentPasswordController,
                    labelText: "현재 비밀번호",
                    hintText: "현재 비밀번호",
                    errorText: controller.currentPasswordError.value,
                    isObscured: controller.isPasswordObscured.isTrue,
                    onChanged: (value) => controller.currentPasswordValidator(value),
                    keyboardType: TextInputType.visiblePassword,
                    suffixWidget: InkWell(
                      onTap: controller.isPasswordObscured.isTrue ? controller.showPassword : controller.obscurePassword,
                      child: Text(
                        controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
                        style: StyledFont.CAPTION_1_GRAY,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('새로운 비밀번호를 입력해주세요', style: StyledFont.BODY,),
                const SizedBox(height: 16),
                Obx(
                  () => InputTextFormField(
                    controller: controller.newPasswordController,
                    labelText: "새로운 비밀번호",
                    hintText: "새로운 비밀번호",
                    errorText: controller.newPasswordError.value,
                    isObscured: controller.isPasswordObscured.isTrue,
                    onChanged: (value) => controller.newPasswordValidator(value),
                    keyboardType: TextInputType.visiblePassword,
                    suffixWidget: InkWell(
                      onTap: controller.isPasswordObscured.isTrue ? controller.showPassword : controller.obscurePassword,
                      child: Text(
                        controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
                        style: StyledFont.CAPTION_1_GRAY,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => InputTextFormField(
                    controller: controller.newPasswordConfirmController,
                    labelText: "새로운 비밀번호 확인",
                    hintText: "새로운 비밀번호 확인",
                    errorText: controller.newPasswordConfirmError.value,
                    isObscured: controller.isPasswordObscured.isTrue,
                    onChanged: (value) => controller.newPasswordConfirmValidator(value),
                    keyboardType: TextInputType.visiblePassword,
                    suffixWidget: InkWell(
                      onTap: controller.isPasswordObscured.isTrue ? controller.showPassword : controller.obscurePassword,
                      child: Text(
                        controller.isPasswordObscured.isTrue ? "비밀번호 보이기" : "비밀번호 숨기기",
                        style: StyledFont.CAPTION_1_GRAY,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SubmitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends GetView<UpdatePasswordController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.updatePassword,
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
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}
