import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/PageNames.dart';
import '../../../model/Schedule.dart';
import '../component/bottomSheet/ScheduleBottomSheet.dart';

const dayList = ['일', '월', '화', '수', '목', '금', '토'];

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  static HomeController to = Get.find();

  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);

  final Rx<bool> isSelecting = RxBool(false);
  Set<int> previousSelectedIndexList = {};

  /// Select Schedule
  final Rxn<Schedule> selectedSchedule = Rxn(null);
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");

  // final Rx<int> selectedScheduleStartAt = Rx(0);
  // final Rx<int> selectedScheduleEndAt = Rx(0);

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
      Schedule(
          scheduleId: 1,
          scheduleDate: DateTime(2023, 3, 10),
          scheduleIndexList: [13, 14, 15],
          scheduleColorHex: "859039",
          scheduleName: "코딩 공부",
          scheduleDetail: "DateTime 공부",
          scheduleDone: false),
      Schedule(
          scheduleId: 1,
          scheduleDate: DateTime(2023, 3, 10),
          scheduleIndexList: [38, 39, 40, 41, 42, 43],
          scheduleColorHex: "77DD77",
          scheduleName: "코딩",
          scheduleDetail: "DateTime 작업",
          scheduleDone: false),
    ]);
    scheduleList.refresh();
  }

  void createSchedule(List<int> indexList) async {
    final Schedule? schedule = await Get.toNamed(PageNames.CREATE, arguments: indexList) as Schedule?;
    if (schedule == null) return;

    await uploadSchedule(schedule: schedule);
    confirmSelection();
  }

  Future<void> selectSchedule({required Schedule schedule}) async {
    selectedSchedule.value = schedule;
    selectedDate.value = schedule.scheduleDate;
    selectedDateText.value = dateToString(date: schedule.scheduleDate);
  }

  void showScheduleDetail(Schedule schedule) async {
    await selectSchedule(schedule: schedule);
    bool? isSaved = await Get.bottomSheet(const ScheduleBottomSheet()) as bool?;

    if (isSaved == null) return;
  }

  Future<void> uploadSchedule({required Schedule schedule}) async {}

  void confirmSelection() {}

  String dateToString({required DateTime date}) {
    return '${date.year}년 ${date.month}월 ${date.day}일 (${dayList[date.weekday % 7]})';
  }

  /// BottomSheet
  void onTapBottomSheet() async {}

  void closeScheduleBottomSheet() {}

  void deleteSchedule() async {
    // TODO : [Feat] Create Function to Delete Schedule
  }

  void saveSchedule() async {
    // TODO : [Feat] Create Function to Delete Schedule
  }
}
