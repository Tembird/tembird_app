import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/HelpRepository.dart';

class ContactController extends GetxController {
  final HelpRepository helpRepository = HelpRepository();
  static ContactController to = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final RxnString titleError = RxnString(null);
  final RxBool onLoading = RxBool(false);

  void titleValidator() {
    if (titleController.value.text.isEmpty) {
      titleError.value = '제목은 필수입니다.';
      return;
    }
    titleError.value = null;
  }

  void submit() async {
    onLoading.value = true;
    try {
      titleValidator();
      if (titleError.value != null) return;
      await helpRepository.submitFeedback();
      Get.back();
    } finally {
      onLoading.value = false;
    }
  }
}