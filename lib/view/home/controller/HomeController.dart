import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/PageNames.dart';
import '../../../model/Schedule.dart';

const dayList = ['일', '월', '화', '수', '목', '금', '토'];

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  static HomeController to = Get.find();

  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);

  final Rx<bool> isSelecting = RxBool(false);
  Set<int> previousSelectedIndexList = {};

  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");

  @override
  void onInit() async {
    // EasyLoading.show
    onLoading.value = true;
    selectedDateText.value = dateToString(date: selectedDate.value);
    tabController = TabController(vsync: this, length: 2);
    await getScheduleList();
    super.onInit();
    onLoading.value = false;
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }

  Future<void> getScheduleList() async {
    scheduleList.clear();
    scheduleList.addAll([
      Schedule(scheduleId: 1, schedulePointList: [Point<int>(1, 2), Point<int>(2, 2), Point<int>(3, 2)], scheduleColorHex: "859039", scheduleName: "코딩 공부", scheduleDetail: "DateTime 공부", scheduleDone: false),
      Schedule(scheduleId: 1, schedulePointList: [Point<int>(2, 6), Point<int>(3, 6), Point<int>(4, 6), Point<int>(5, 6), Point<int>(0, 7), Point<int>(1, 7)], scheduleColorHex: "77DD77", scheduleName: "코딩", scheduleDetail: "DateTime 작업", scheduleDone: false),
    ]);
    scheduleList.refresh();
  }

  void createSchedule(List<Point<int>> pointList) async {
    final Schedule? schedule = await Get.toNamed(PageNames.CREATE, arguments: pointList) as Schedule?;
    if (schedule == null) return;

    await uploadSchedule(schedule: schedule);
    confirmSelection();
  }

  void showScheduleDetail(Schedule schedule) async {
    // await Get.bottomSheet(
    //     BottomSheet(onClosing: () => print("hello"), builder: (context) => Container(
    //       color: Colors.blue,
    //       height: 200,
    //       width: double.infinity,
    //       child: Text(schedule.scheduleName),
    //     ))
    // );
  }

  Future<void> uploadSchedule({required Schedule schedule}) async {
  }

  void confirmSelection() {

  }

  String dateToString({required DateTime date}) {
    return '${date.year}년 ${date.month}월 ${date.day}일 (${dayList[date.weekday%7]})';
  }

  /// BottomSheet
  void onTapBottomSheet() async {

  }
}