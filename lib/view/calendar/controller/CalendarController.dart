import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/model/ModalAction.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/service/RootController.dart';

class CalendarController extends RootController {
  final DateTime initDate;
  static CalendarController to = Get.find();

  CalendarController({required this.initDate});

  double? y;
  final Rx<bool> onLoading = RxBool(true);

  final Rxn<DateTime> selectedDate = Rxn(null);
  final RxString selectedDateText = RxString('');
  @override
  void onInit() async {
    onLoading.value = true;
    selectedDate.value = initDate;
    selectedDateText.value = dateToString(date: initDate);
    onLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    selectedDateText.value = dateToString(date: date);
  }

  /// BottomSheet
  void dragStart(double start) {
    y = start;
  }

  void dragCancel() {
    y = null;
  }

  void dragUpdate(double current) {
    if (y == null || current < (y! + 30)) return;
    closeCalendar();
  }

  /// Ads
  void tapAds() {
    // TODO : [Feat] Link to Advertisement
    print('=======> Show Ads');
  }

  void closeCalendar() {
    Get.back();
  }

  void confirmCalendar() {
    if (selectedDate.value == initDate) {
      Get.back();
      return;
    }
    Get.back(result: selectedDate.value);
  }
}
