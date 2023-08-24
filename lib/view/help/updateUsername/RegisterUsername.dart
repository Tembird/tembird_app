import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/component/InputTextFormField.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import 'controller/UpdateUsernameController.dart';

class RegisterUsernameView extends GetView<UpdateUsernameController> {
  static String routeName = '/auth/register-username';
  const RegisterUsernameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 생성', style: StyledFont.TITLE_2),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Tembird가 어떻게 불러드릴까요?', style: StyledFont.TITLE_3,),
                const SizedBox(height: 16),
                Obx(
                      () => InputTextFormField(
                    controller: controller.usernameController,
                    labelText: '아이디',
                    hintText: '사용하실 아이디를 입력해주세요',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.checkPossibleUsername(),
                    errorText: controller.usernameError.value,
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

class SubmitButton extends GetView<UpdateUsernameController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.updateUsername,
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
