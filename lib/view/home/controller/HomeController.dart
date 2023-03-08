import 'dart:math';
import 'package:get/get.dart';

import '../../../constant/PageNames.dart';
import '../../../model/Schedule.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();


  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);

  final Rx<bool> isSelecting = RxBool(false);
  Set<int> previousSelectedIndexList = {};

  @override
  void onInit() async {
    await getScheduleList();
    super.onInit();
  }

  Future<void> getScheduleList() async {
    // EasyLoading.show
    onLoading.value = true;
    scheduleList.clear();
    scheduleList.addAll([
      Schedule(scheduleId: 1, schedulePointList: [Point<int>(1, 2), Point<int>(2, 2), Point<int>(3, 2)], scheduleColorHex: "859039", scheduleName: "코딩 공부", scheduleDetail: "DateTime 공부", scheduleDone: false),
      Schedule(scheduleId: 1, schedulePointList: [Point<int>(2, 6), Point<int>(3, 6), Point<int>(4, 6), Point<int>(5, 6)], scheduleColorHex: "124000", scheduleName: "코딩", scheduleDetail: "DateTime 작업", scheduleDone: false),
    ]);
    scheduleList.refresh();
    onLoading.value = false;
  }

  void createSchedule(List<Point<int>> pointList) async {
    final Schedule? schedule = await Get.toNamed(PageNames.CREATE, arguments: pointList) as Schedule?;
    if (schedule == null) return;

    await uploadSchedule(schedule: schedule);
    confirmSelection();
  }

  void showScheduleDetail(Schedule schedule) async {
    print(schedule.scheduleName);
  }

  Future<void> uploadSchedule({required Schedule schedule}) async {
  }

  void confirmSelection() {

  }
}