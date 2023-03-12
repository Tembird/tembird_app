import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/PageNames.dart';
import 'package:tembird_app/model/ScheduleAction.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/calendar/CalendarView.dart';
import '../../../model/Schedule.dart';
import '../../create/schedule/CreateScheduleView.dart';

class HomeController extends RootController with GetSingleTickerProviderStateMixin {
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  TabController? tabController;
  static HomeController to = Get.find();

  final RxInt viewIndex = RxInt(0);

  final Rx<DateTime> scheduleListUpdatedAt = Rx(DateTime.now());
  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);

  /// Select Schedule
  final Rx<DateTime> selectedDate = Rx(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  final Rx<String> selectedDateText = Rx("");

  @override
  void onInit() async {
    selectedDateText.value = dateToString(date: selectedDate.value);
    tabController = TabController(vsync: this, length: 2);
    await getScheduleList(selectedDate.value);
    super.onInit();
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }

  Future<void> getScheduleList(DateTime date) async {
    onLoading.value = true;
    try {
      List<Schedule> list = await scheduleRepository.readScheduleListOnDate(dateTime: date);
      scheduleList.clear();
      scheduleList.addAll(list);
      updateEditedAt();
    } finally {
      scheduleList.refresh();
      onLoading.value = false;
    }
  }

  void selectView(int index) {
    if (viewIndex.value == index) return;
    viewIndex.value = index;
  }

  void createSchedule(List<int> indexList) async {
    final Schedule schedule = Schedule(
        scheduleId: 0,
        scheduleDate: selectedDate.value,
        scheduleIndexList: indexList,
        scheduleColorHex: '000000',
        scheduleMember: [],
        scheduleDone: false,
    );

    ScheduleAction? scheduleAction = await Get.bottomSheet(
      CreateScheduleView.route(schedule, true),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as ScheduleAction?;

    if (scheduleAction == null || scheduleAction.action != ActionType.created) return;
    addSchedule(add: scheduleAction.schedule!);
  }

  void showScheduleDetail(Schedule schedule) async {
    ScheduleAction? scheduleAction = await Get.bottomSheet(
      CreateScheduleView.route(schedule, false),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as ScheduleAction?;

    if (scheduleAction == null) return;

    switch (scheduleAction.action) {
      case ActionType.created:
        addSchedule(add: scheduleAction.schedule!);
        return;
      case ActionType.updated:
        updateSchedule(previous: schedule, update: scheduleAction.schedule!);
        return;
      case ActionType.removed:
        removeSchedule(removed: schedule);
        return;
    }
  }

  void addSchedule({required Schedule add}) {
    scheduleList.add(add);
    scheduleList.refresh();
    updateEditedAt();
  }

  void updateSchedule({required Schedule previous, required Schedule update}) {
    scheduleList.remove(previous);
    scheduleList.add(update);
    scheduleList.refresh();
    updateEditedAt();
  }

  void removeSchedule({required Schedule removed}) {
    scheduleList.remove(removed);
    scheduleList.refresh();
    updateEditedAt();
  }

  void updateEditedAt() {
    scheduleListUpdatedAt.value = DateTime.now();
  }

  /// BottomSheet
  void showCalendar() async {
    DateTime? newDate = await Get.bottomSheet(
      CalendarView.route(selectedDate.value),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as DateTime?;

    if (newDate == null) return;
    await getScheduleList(newDate);
    selectedDate.value = newDate;
    selectedDateText.value = dateToString(date: newDate);
  }

  void openHelpView() {
    Get.toNamed(PageNames.HELP);
  }
}
