import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import '../../../component/InputTextFormField.dart';
import 'controller/ContactController.dart';

class ContactView extends GetView<ContactController> {
  static String routeName = '/help/contact';
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: StyledPalette.BLACK,
          onPressed: Get.back,
        ),
        title: const Text('이용 문의', style: StyledFont.TITLE_2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                    () => InputTextFormField(
                  labelText: '제목',
                  controller: controller.titleController,
                  hintText: "제목을 입력해주세요",
                  onChanged: (_) => controller.titleValidator(),
                  errorText: controller.titleError.value,
                ),
              ),
              const SizedBox(height: 16),
              const Text("상세 내용", style: StyledFont.HEADLINE),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.contentController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    isDense: true,
                    hintText: '내용을 입력해주세요',
                    hintStyle: StyledFont.BODY_GRAY,
                  ),
                  maxLines: 10,
                  style: StyledFont.BODY,
                ),
              ),
              const SizedBox(height: 16),
              const SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends GetView<ContactController> {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.submit,
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
            '제출',
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}
