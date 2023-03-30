import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/PageNames.dart';
import 'package:tembird_app/model/ScheduleAction.dart';
import 'package:tembird_app/repository/InitRepository.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/repository/TodoRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/calendar/CalendarView.dart';
import '../../../constant/StyledPalette.dart';
import '../../../model/CellStyle.dart';
import '../../../model/ModalAction.dart';
import '../../../model/Schedule.dart';
import '../../../model/Todo.dart';
import '../../create/schedule/CreateScheduleView.dart';

class HomeController extends RootController with GetSingleTickerProviderStateMixin {
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  final TodoRepository todoRepository = TodoRepository();
  final InitRepository initRepository = InitRepository();
  TabController? tabController;
  static HomeController to = Get.find();
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");
  final RxInt viewIndex = RxInt(0);

  final RxList<Schedule> scheduleList = RxList([]);
  final RxList<String> scheduleColorHexList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);


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
    scheduleColorHexList.clear();
    try {
      List<String> list = await initRepository.readScheduleColorHexList();
      scheduleColorHexList.addAll(list);
    } catch (e) {
      print(e);
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
      sid: '',
      date: selectedDate.value,
      startAt: indexList.first,
      endAt: indexList.last,
      scheduleIndexList: indexList,
      colorHex: scheduleColorHexList.first,
      // memberList: [],
      done: false,
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
      todoList: [],
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

  void showScheduleActionModal(Schedule schedule) async {
    final List<ModalAction> modalActionList = [
      ModalAction(name: '수정하기', onPressed: () => Get.back(result: 0), isNegative: false),
      ModalAction(name: '삭제하기', onPressed: () => Get.back(result: 1), isNegative: false),
    ];
    int? action = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: schedule.title,
    );
    if (action == null) return;
    if (action == 0) {
      showScheduleDetail(schedule);
      return;
    }
    if (action == 1) {
      removeSchedule(removed: schedule);
    }
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
      sid: add.sid,
      date: add.date,
      startAt: add.scheduleIndexList.first,
      endAt: add.scheduleIndexList.last,
      scheduleIndexList: add.scheduleIndexList,
      colorHex: add.colorHex,
      // memberList: add.memberList,
      done: add.done,
      location: add.location,
      detail: add.detail,
      title: add.title,
      createdAt: add.createdAt,
      editedAt: add.editedAt,
      todoList: add.todoList,
    ));
    scheduleList.sort((a,b) => a.scheduleIndexList.first.compareTo(b.scheduleIndexList.first));
    selectedIndexList.clear();
    unselectableIndexList.clear();
    for (var schedule in scheduleList) {
      unselectableIndexList.addAll(schedule.scheduleIndexList);
    }
    startIndex.value = null;
    endIndex.value = null;
    // minUnselectableIndex = 144;
    refreshCellStyleList();
  }

  void updateSchedule({required Schedule previous, required Schedule update}) {
    scheduleList.removeWhere((schedule) => schedule.sid == previous.sid);
    scheduleList.add(update);
    refreshCellStyleList();
  }

  void removeSchedule({required Schedule removed}) {
    unselectableIndexList.removeWhere((index) => removed.scheduleIndexList.contains(index));
    scheduleList.removeWhere((schedule) => schedule.sid == removed.sid);
    refreshCellStyleList();
  }

  Future<void> changeScheduleStatus({required Schedule schedule}) async {
    Schedule changedSchedule = Schedule(
      sid: schedule.sid,
      date: schedule.date,
      startAt: schedule.scheduleIndexList.first,
      endAt: schedule.scheduleIndexList.last,
      scheduleIndexList: schedule.scheduleIndexList,
      colorHex: schedule.colorHex,
      // memberList: schedule.memberList,
      done: !schedule.done,
      createdAt: schedule.createdAt,
      editedAt: DateTime.now(),
      title: schedule.title,
      detail: schedule.detail,
      location: schedule.location,
      doneAt: !schedule.done ? DateTime.now() : null,
      todoList: schedule.todoList,
    );
    try {
      await scheduleRepository.updateSchedule(schedule: changedSchedule, removedTidList: []);
      scheduleList.firstWhere((e) => e == schedule).done = changedSchedule.done;
    } finally {
      scheduleList.refresh();
      // refreshCellStyleList();
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
  List<int> unselectableIndexList = [];
  List<int> selectedIndexList = [];
  // int? startIndex;
  // int? endIndex;
  Rxn<int> startIndex = Rxn(null);
  Rxn<int> endIndex = Rxn(null);
  // int minUnselectableIndex = 144;

  final double tableWidth = Get.width < 400 ? Get.width : 400;
  final double cellWidth = ((Get.width < 400 ? Get.width : 400) - 32) / 6;
  final double cellHeight = 45;
  final RxList<CellStyle> cellStyleList = RxList(List.generate(144, (index) => CellStyle(length: 1)));

  void onTableTapDown(TapDownDetails details) async {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    if (selectedIndexList.contains(selectedIndex)) {
      createSchedule(selectedIndexList);
      return;
    }
    if (endIndex.value != null) {
      startIndex.value = null;
      endIndex.value = null;
      // minUnselectableIndex = 144;
      selectedIndexList.clear();
      // refreshCellStyleList();
      return;
    }
    final int scheduleIndex = scheduleList.indexWhere((schedule) => schedule.scheduleIndexList.contains(selectedIndex));
    if (scheduleIndex == -1) return;

    final Schedule schedule = scheduleList[scheduleIndex];
    showScheduleDetail(schedule);
    // refreshCellStyleList();
  }

  void onTableLongPressStart(LongPressStartDetails details) {
    selectedIndexList.clear();
    int selectedIndex = getIndexFromPosition(details.localPosition);
    // getMinUnselectableIndex(selectedIndex);
    // if (!isEnableIndex(selectedIndex)) return;
    startIndex.value = selectedIndex;
    // endIndex = null;
    endIndex.value = selectedIndex;
    // refreshCellStyleList();
  }

  void onTableLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    // if (startIndex == null || !isEnableIndex(selectedIndex)) {
    //   return;
    // }
    if (startIndex.value == null) return;
    endIndex.value = selectedIndex;
    // refreshCellStyleList();
  }

  void onTableLongPressEnd(LongPressEndDetails details) {
    // minUnselectableIndex = 144;
    if (startIndex.value == null || endIndex.value == null) return;
    if (unselectableIndexList.any((index) => index >= startIndex.value! && index <= endIndex.value!)) {
      startIndex.value = null;
      endIndex.value = null;
      showAlertDialog(message: '선택하신 시간에 이미 일정이 있습니다\n기존 일정을 삭제하신 후 다시 시도해주세요');
      return;
    }
    selectedIndexList.clear();
    selectedIndexList.addAll(List.generate(endIndex.value! - startIndex.value! + 1, (index) => startIndex.value! + index));
    // TODO : 중복 체크 및 작업 선택 팝업 표시
    // setSelectedIndexList();
  }

  // void getMinUnselectableIndex(int currentIndex) {
  //   if (unselectableIndexList.contains(currentIndex)) {
  //     minUnselectableIndex = currentIndex;
  //     return;
  //   }
  //   int minDistance = 144;
  //   for (int i = 0; i < unselectableIndexList.length; i++) {
  //     int unselectableIndex = unselectableIndexList[i];
  //     int distance = unselectableIndex - currentIndex;
  //     if (distance > 0 && distance < minDistance) {
  //       minDistance = distance;
  //       minUnselectableIndex = unselectableIndex;
  //     }
  //   }
  // }
  //
  // bool isEnableIndex(int index) {
  //   return (minUnselectableIndex - index) > 0;
  // }

  Color? getIndexColor(int index) {
    if (unselectableIndexList.contains(index)) {
      String colorHex = scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.contains(index)).colorHex;
      return Color(int.parse(colorHex, radix: 16) + 0xFF000000);
    }
    return null;
  }

  Schedule? getIndexSchedule(int index) {
    try {
      return scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.contains(index));
    } catch (e) {
      return null;
    }
  }

  bool isSelectedIndex(int index) {
    if (startIndex.value == null || endIndex.value == null) {
      return false;
    }
    return !(index - startIndex.value!).isNegative && !(endIndex.value! - index).isNegative;
  }

  int getIndexFromPosition(Offset position) {
    final int x = position.dx ~/ cellWidth;
    final int y = position.dy ~/ cellHeight;
    return (x + 6 * y);
  }

  // void setSelectedIndexList() {
  //   for (int index = startIndex.value!; index < endIndex.value! + 1; index++) {
  //     selectedIndexList.add(index);
  //   }
  // }

  void refreshCellStyleList() async {
    cellStyleList.clear();

    int columnSpan = 0;
    int span = 0;
    Color? scheduleColor;
    String? title;
    for (int index = 0; index < 144; index++) {
      if (columnSpan > 0) {
        cellStyleList.add(CellStyle(length: 0));
        columnSpan--;
        span--;
        continue;
      }

      if (span > 0) {
        columnSpan = span ~/ 6 > 0 ? 6 : span;
        cellStyleList.add(CellStyle(length: columnSpan, text: title, color: scheduleColor));
        title = null;
        span--;
        columnSpan--;
        continue;
      }

      Schedule? schedule = getIndexSchedule(index);
      if (schedule == null) {
        cellStyleList.add(CellStyle(length: 1));
        continue;
      }

      span = schedule.endAt - schedule.startAt + 1;
      columnSpan = schedule.endAt ~/ 6 == schedule.startAt ~/ 6 ? span : 6 - schedule.startAt % 6;
      scheduleColor = Color(int.parse(schedule.colorHex, radix: 16) + 0xFF000000);
      bool isTitleOnFirstLine = columnSpan > 3 || columnSpan + 1 > span - columnSpan;
      title = schedule.title ?? '제목 없음';
      cellStyleList.add(CellStyle(length: columnSpan, text: isTitleOnFirstLine ? title : null, color: scheduleColor));
      columnSpan--;
      span--;
      if (isTitleOnFirstLine) {
        title = null;
      }
    }
  }

  /// HomeTodoList
  void onDone({required Todo todo}) {
    updateTodoStatus(todo: todo, updatedStatus: TodoStatus.notStarted);
  }

  void onNotStated({required Todo todo}) {
    updateTodoStatus(todo: todo, updatedStatus: TodoStatus.notStarted);
  }

  void onPass({required Todo todo}) {
    updateTodoStatus(todo: todo, updatedStatus: TodoStatus.pass);
  }

  void updateTodoStatus({required Todo todo, required int updatedStatus}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      // Todo updatedTodo = Todo(
      //   tid: todo.tid,
      //   todoTitle: todo.todoTitle,
      //   todoStatus: TodoStatus.notStarted,
      //   todoUpdatedAt: todo.todoUpdatedAt,
      // );
      // await todoRepository.updateTodo(todo: updatedTodo);
    } finally {
      onLoading.value = false;
    }
  }
}
