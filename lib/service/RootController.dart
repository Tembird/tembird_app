import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/ModalAction.dart';

const dayList = ['일', '월', '화', '수', '목', '금', '토'];

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
            isDestructiveAction: modalActionList[index].isNegative,
            child: Text(modalActionList[index].name),
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          child: const Text('취소'),
        ),
      ),
    );
  }

  Future<void> showAlertDialog({String? title, required String message}) async {
    return Get.dialog(CupertinoAlertDialog(
      title: title == null ? null : Text(title),
      content: Text(message),
    ));
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String dateToString({required DateTime date}) => '${date.year}년 ${date.month}월 ${date.day}일 (${dayList[date.weekday % 7]})';
  String dateTimeToString({required DateTime date}) => '${date.year}년 ${date.month}월 ${date.day}일 (${dayList[date.weekday % 7]}) ${date.hour}시 ${date.minute}분';
  DateTime indexToDateTime({required DateTime date, required int index}) => DateTime(date.year, date.month, date.day, (index + 1) ~/ 6, ((index + 1) % 6) * 10);
}
