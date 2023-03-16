import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/PageNames.dart';
import 'package:tembird_app/model/ScheduleAction.dart';
import 'package:tembird_app/repository/InitRepository.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/calendar/CalendarView.dart';
import '../../../constant/StyledPalette.dart';
import '../../../model/Schedule.dart';
import '../../create/schedule/CreateScheduleView.dart';

class HomeController extends RootController with GetSingleTickerProviderStateMixin {
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  final InitRepository initRepository = InitRepository();
  TabController? tabController;
  static HomeController to = Get.find();

  final RxInt viewIndex = RxInt(0);

  final Rx<DateTime> scheduleListUpdatedAt = Rx(DateTime.now());
  final RxList<Schedule> scheduleList = RxList([]);
  final RxList<String> scheduleColorHexList = RxList([]);
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
    await getScheduleHexList();
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
      unselectableIndexList.clear();
      for (var schedule in scheduleList) {
        unselectableIndexList.addAll(schedule.scheduleIndexList);
      }
      refreshCellStyleList();
    } finally {
      scheduleList.refresh();
      onLoading.value = false;
    }
  }

  Future<void> getScheduleHexList() async {
    try {
      List<String> list = await initRepository.getScheduleColorHexList();
      scheduleColorHexList.clear();
      scheduleColorHexList.addAll(list);
    } catch (e) {
      scheduleColorHexList.clear();
      scheduleColorHexList.addAll(StyledPalette.DEFAULT_SCHEDULE_COLOR_LIST);
    } finally {
      scheduleColorHexList.refresh();
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
      scheduleColorHex: StyledPalette.DEFAULT_SCHEDULE_COLOR,
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
    scheduleList.add(Schedule(
      scheduleId: add.scheduleId,
      scheduleDate: add.scheduleDate,
      scheduleIndexList: add.scheduleIndexList.toList(),
      scheduleColorHex: add.scheduleColorHex,
      scheduleMember: add.scheduleMember.toList(),
      scheduleDone: add.scheduleDone,
      scheduleLocation: add.scheduleLocation,
      scheduleDetail: add.scheduleDetail,
      scheduleTitle: add.scheduleTitle,
    ));
    scheduleList.sort((a,b) => a.scheduleIndexList.first.compareTo(b.scheduleIndexList.first));
    selectedIndexList.clear();
    unselectableIndexList.clear();
    for (var schedule in scheduleList) {
      unselectableIndexList.addAll(schedule.scheduleIndexList);
    }
    startIndex = null;
    endIndex = null;
    minUnselectableIndex = 144;
    refreshCellStyleList();
  }

  void updateSchedule({required Schedule previous, required Schedule update}) {
    scheduleList.remove(previous);
    scheduleList.add(update);
    refreshCellStyleList();
  }

  void removeSchedule({required Schedule removed}) {
    unselectableIndexList.removeWhere((index) => removed.scheduleIndexList.contains(index));
    scheduleList.removeWhere((schedule) => schedule.scheduleId == removed.scheduleId);
    refreshCellStyleList();
  }

  Future<void> changeScheduleStatus({required Schedule schedule}) async {
    Schedule changedSchedule = Schedule(
        scheduleId: schedule.scheduleId,
        scheduleDate: schedule.scheduleDate,
        scheduleIndexList: schedule.scheduleIndexList,
        scheduleColorHex: schedule.scheduleColorHex,
        scheduleMember: schedule.scheduleMember,
        scheduleDone: !schedule.scheduleDone);
    try {
      await scheduleRepository.updateSchedule(schedule: changedSchedule);
      scheduleList.firstWhere((e) => e == schedule).scheduleDone = changedSchedule.scheduleDone;
    } finally {
      scheduleList.refresh();
      refreshCellStyleList();
    }
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

  // TODD : ScheduleTable
  final List<int> hourList = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3];
  List<int> unselectableIndexList = [];
  List<int> selectedIndexList = [];
  int? startIndex;
  int? endIndex;
  int minUnselectableIndex = 144;
  final double cellWidth = (Get.width - 32) / 6;
  final double cellHeight = 45;
  final RxList<CellStyle> cellStyleList = RxList([]);

  void onTableTapDown(TapDownDetails details) async {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    if (selectedIndexList.contains(selectedIndex)) {
      createSchedule(selectedIndexList);
      return;
    }
    if (endIndex != null) {
      startIndex = null;
      endIndex = null;
      minUnselectableIndex = 144;
      selectedIndexList.clear();
      refreshCellStyleList();
      return;
    }
    final int scheduleIndex = scheduleList.indexWhere((schedule) => schedule.scheduleIndexList.contains(selectedIndex));
    if (scheduleIndex == -1) return;

    final Schedule schedule = scheduleList[scheduleIndex];
    showScheduleDetail(schedule);
    refreshCellStyleList();
  }

  void onTableLongPressStart(LongPressStartDetails details) {
    selectedIndexList.clear();
    int selectedIndex = getIndexFromPosition(details.localPosition);
    getMinUnselectableIndex(selectedIndex);
    if (!isEnableIndex(selectedIndex)) return;
    startIndex = selectedIndex;
    endIndex = null;
    refreshCellStyleList();
  }

  void onTableLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    if (startIndex == null || !isEnableIndex(selectedIndex)) {
      return;
    }
    endIndex = selectedIndex;
    refreshCellStyleList();
  }

  void onTableLongPressEnd(LongPressEndDetails details) {
    minUnselectableIndex = 144;
    if (startIndex == null || endIndex == null) return;
    setSelectedIndexList();
  }

  void getMinUnselectableIndex(int currentIndex) {
    if (unselectableIndexList.contains(currentIndex)) {
      minUnselectableIndex = currentIndex;
      return;
    }
    int minDistance = 144;
    for (int i = 0; i < unselectableIndexList.length; i++) {
      int unselectableIndex = unselectableIndexList[i];
      int distance = unselectableIndex - currentIndex;
      if (distance > 0 && distance < minDistance) {
        minDistance = distance;
        minUnselectableIndex = unselectableIndex;
      }
    }
  }

  bool isEnableIndex(int index) {
    return (minUnselectableIndex - index) > 0;
  }

  Color? getIndexColor(int index) {
    if (unselectableIndexList.contains(index)) {
      String colorHex = scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.contains(index)).scheduleColorHex;
      return Color(int.parse(colorHex, radix: 16) + 0xFF000000);
    }
    return null;
  }

  Schedule? getIndexSchedule(int index) {
    try {
      return scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.first == index);
    } catch (e) {
      return null;
    }
  }

  bool isSelectedIndex(int index) {
    if (startIndex == null || endIndex == null) {
      return false;
    }
    return !(index - startIndex!).isNegative && !(endIndex! - index).isNegative;
  }

  int getIndexFromPosition(Offset position) {
    final int x = position.dx ~/ cellWidth;
    final int y = position.dy ~/ cellHeight;
    return (x + 6 * y);
  }

  void setSelectedIndexList() {
    for (int index = startIndex!; index < endIndex! + 1; index++) {
      selectedIndexList.add(index);
    }
  }

  void refreshCellStyleList() async {
    cellStyleList.clear();

    int columnSpan = 0;
    for (int index = 0; index < 144; index++) {
      if (columnSpan > 1) {
        cellStyleList.add(CellStyle(length: 0));
        columnSpan--;
        continue;
      }

      Schedule? schedule = getIndexSchedule(index);
      if (schedule == null) {
        cellStyleList.add(CellStyle(
          length: 1,
          color: getIndexColor(index) ?? (isSelectedIndex(index) ? Colors.blue : null),
        ));
        continue;
      }

      columnSpan = schedule.scheduleIndexList.where((schedule) => schedule ~/ 6 == index ~/ 6).length;
      Color scheduleColor = Color(int.parse(schedule.scheduleColorHex, radix: 16) + 0xFF000000);
      cellStyleList.add(CellStyle(length: columnSpan, text: schedule.scheduleTitle ?? '제목 없음', color: scheduleColor));
    }
  }
}

class CellStyle {
  final int length;
  final String? text;
  final Color? color;

  CellStyle({
    required this.length,
    this.text,
    this.color,
  });
}
