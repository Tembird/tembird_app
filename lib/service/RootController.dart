import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/ModalAction.dart';

class RootController extends GetxController {
  static RootController to = Get.find();

  Future<dynamic> showCupertinoActionSheet({required List<ModalAction> modalActionList, String? title, String? message}) async {
    return await Get.bottomSheet(
      CupertinoActionSheet(
        title: title == null ? null : Text(title),
        message: message == null ? null : Text(message),
        actions: List.generate(
            modalActionList.length,
            (index) => CupertinoActionSheetAction(
                  onPressed: modalActionList[index].onPressed,
                  child: Text(modalActionList[index].name),
                )),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          child: const Text('취소'),
        ),
      ),
    );
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
