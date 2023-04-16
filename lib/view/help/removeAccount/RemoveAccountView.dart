import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/component/InputTextFormField.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import 'controller/RemoveAccountController.dart';

class RemoveAccountView extends GetView<RemoveAccountController> {
  static String routeName = '/help/remove-account';
  const RemoveAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 삭제', style: StyledFont.TITLE_2),
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
                const Text('계정 삭제 30일 이내로 복구 가능합니다', style: StyledFont.BODY_NEGATIVE,),
                const SizedBox(height: 16),
                const Text('비밀번호를 입력해주세요', style: StyledFont.BODY,),
                const SizedBox(height: 16),
                Obx(
                  () => InputTextFormField(
                    controller: controller.passwordController,
                    labelText: "현재 비밀번호",
                    hintText: "현재 비밀번호",
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

class SubmitButton extends GetView<RemoveAccountController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.removeAccount,
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
            '확인',
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}
