import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/component/InputTextFormField.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/help/updateId/controller/UpdateIdController.dart';

class UpdateIdView extends GetView<UpdateIdController> {
  const UpdateIdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 설정', style: StyledFont.TITLE_2),
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
                Obx(
                  () => InputTextFormField(
                    controller: controller.userIdController,
                    labelText: '아이디',
                    hintText: '사용하실 아이디를 설정해주세요',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.checkPossibleId(),
                    errorText: controller.userIdError.value,
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

class SubmitButton extends GetView<UpdateIdController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.updateId,
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
