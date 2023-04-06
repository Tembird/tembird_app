import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/PageNames.dart';
import 'package:tembird_app/model/ScheduleAction.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/InitRepository.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/repository/TodoRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/calendar/CalendarView.dart';
import 'package:tembird_app/view/dialog/todoLabel/select/SelectTodoLabelDialogView.dart';
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
  double? x;

  static HomeController to = Get.find();
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");
  final RxInt viewIndex = RxInt(0);

  final RxList<Schedule> scheduleList = RxList([]);
  final RxList<String> scheduleColorHexList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);
  final RxBool onCreateTodo = RxBool(false);
  final Rxn<int> editingScheduleIndex = Rxn(null);
  final Rxn<int> editingTodoIndex = Rxn(null);
  final TextEditingController todoEditingController = TextEditingController();


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
    todoEditingController.dispose();
    super.onClose();
  }

  void resetTextFormField() {
    onCreateTodo.value = false;
    editingScheduleIndex.value = null;
    editingTodoIndex.value = null;
  }

  void dragHorizontalStart(double start) {
    x = start;
  }

  void dragHorizontalCancel() {
    x = null;
  }

  void dragHorizontalUpdate(double current) async {
    if (x == null) return;
    if (current < (x! + 30) && current > (x! - 30)) {
      return;
    }
    double startX = x!;
    x = null;
    DateTime? newDate;

    if (current > (startX + 30)) {
      newDate = selectedDate.value.subtract(const Duration(days: 1));
    }
    if (current < (startX - 30)) {
      newDate = selectedDate.value.add(const Duration(days: 1));
    }
    await getScheduleList(newDate!);
    selectedDate.value = newDate;
    selectedDateText.value = dateToString(date: newDate);
  }

  Future<void> getScheduleList(DateTime date) async {
    onLoading.value = true;
    try {
      List<Schedule> list = await scheduleRepository.readScheduleListOnDate(dateTime: date);
      list.sort((a,b) => a.startAt.compareTo(b.startAt));
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
    if (viewIndex.value == 1) {
      resetTextFormField();
    }
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
      title: schedule.title ?? "제목 없음",
    );
    if (action == null) return;
    if (action == 0) {
      showScheduleDetail(schedule);
      return;
    }
    if (action == 1) {
      removeSchedule(schedule: schedule);
    }
  }

  void removeSchedule({required Schedule schedule}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      await scheduleRepository.deleteSchedule(schedule: schedule);
      deleteRemovedSchedule(removed: schedule);
    } catch (e) {
      return;
    } finally {
      onLoading.value = false;
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
        deleteRemovedSchedule(removed: schedule);
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
      done: add.done,
      location: add.location,
      detail: add.detail,
      title: add.title,
      createdAt: add.createdAt,
      editedAt: add.editedAt,
      todoList: add.todoList,
    ));
    scheduleList.sort((a,b) => a.startAt.compareTo(b.startAt));
    selectedIndexList.clear();
    unselectableIndexList.clear();
    for (var schedule in scheduleList) {
      unselectableIndexList.addAll(schedule.scheduleIndexList);
    }
    startIndex.value = null;
    endIndex.value = null;
    refreshCellStyleList();
  }

  void updateSchedule({required Schedule previous, required Schedule update}) {
    scheduleList[scheduleList.indexWhere((e) => e.sid == previous.sid)] = update;
    scheduleList.refresh();
    refreshCellStyleList();
  }

  void deleteRemovedSchedule({required Schedule removed}) {
    unselectableIndexList.removeWhere((index) => removed.scheduleIndexList.contains(index));
    scheduleList.removeWhere((schedule) => schedule.sid == removed.sid);
    refreshCellStyleList();
  }

  /// BottomSheet
  void showCalendar() async {
    resetTextFormField();
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
    resetTextFormField();
    Get.toNamed(PageNames.HELP);
  }

  /// ScheduleTable
  List<int> unselectableIndexList = [];
  List<int> selectedIndexList = [];
  Rxn<int> startIndex = Rxn(null);
  Rxn<int> endIndex = Rxn(null);

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
      selectedIndexList.clear();
      return;
    }
    final int scheduleIndex = scheduleList.indexWhere((schedule) => schedule.scheduleIndexList.contains(selectedIndex));
    if (scheduleIndex == -1) return;

    final Schedule schedule = scheduleList[scheduleIndex];
    showScheduleDetail(schedule);
  }

  void onTableLongPressStart(LongPressStartDetails details) {
    selectedIndexList.clear();
    int selectedIndex = getIndexFromPosition(details.localPosition);
    startIndex.value = selectedIndex;
    endIndex.value = selectedIndex;
  }

  void onTableLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    if (startIndex.value == null) return;
    endIndex.value = selectedIndex;
  }

  void onTableLongPressEnd(LongPressEndDetails details) {
    if (startIndex.value == null || endIndex.value == null) return;
    if (unselectableIndexList.any((index) => index >= startIndex.value! && index <= endIndex.value!)) {
      startIndex.value = null;
      endIndex.value = null;
      showAlertDialog(message: '선택하신 시간에 이미 일정이 있습니다\n기존 일정을 삭제하신 후 다시 시도해주세요');
      return;
    }
    selectedIndexList.clear();
    selectedIndexList.addAll(List.generate(endIndex.value! - startIndex.value! + 1, (index) => startIndex.value! + index));
  }

  Schedule? getIndexSchedule(int index) {
    try {
      return scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.contains(index));
    } catch (e) {
      return null;
    }
  }

  int getIndexFromPosition(Offset position) {
    final int x = position.dx ~/ cellWidth;
    final int y = position.dy ~/ cellHeight;
    return (x + 6 * y);
  }

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
  void onDone({required Schedule schedule, required Todo todo}) {
    updateTodoStatus(schedule: schedule, todo: todo, updatedStatus: TodoStatus.done);
  }

  void onNotStated({required Schedule schedule, required Todo todo}) {
    updateTodoStatus(schedule: schedule, todo: todo, updatedStatus: TodoStatus.notStarted);
  }

  void onPass({required Schedule schedule, required Todo todo}) {
    updateTodoStatus(schedule: schedule, todo: todo, updatedStatus: TodoStatus.pass);
  }

  void updateTodoStatus({required Schedule schedule, required Todo todo, required int updatedStatus}) async {
    if (onLoading.value == true) return;
    try {
      resetTextFormField();
      onLoading.value = true;
      Todo newTodo = Todo(
        tid: todo.tid,
        todoTitle: todo.todoTitle,
        todoStatus: updatedStatus,
        todoUpdatedAt: todo.todoUpdatedAt,
      );
      final Todo updated = await todoRepository.updateTodo(todo: newTodo);
      scheduleList[scheduleList.indexOf(schedule)].todoList[schedule.todoList.indexOf(todo)] = updated;
      scheduleList.refresh();
    } finally {
      onLoading.value = false;
    }
  }

  void showTodoActionModal({required Schedule schedule, required Todo todo}) async {
    resetTextFormField();
    final List<ModalAction> modalActionList = [
      ModalAction(name: '수정하기', onPressed: () => Get.back(result: 0), isNegative: false),
      ModalAction(name: '삭제하기', onPressed: () => Get.back(result: 1), isNegative: false),
    ];
    int? action = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: todo.todoTitle,
    );
    if (action == null) return;
    if (action == 0) {
      editTodoTitle(schedule: schedule, todo: todo);
      return;
    }
    if (action == 1) {
      removeTodo(schedule: schedule, todo: todo);
      return;
    }
  }

  void removeTodo({required Schedule schedule, required Todo todo}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      await todoRepository.deleteTodo(tid: todo.tid);
      scheduleList[scheduleList.indexWhere((e) => e.sid == schedule.sid)].todoList.removeWhere((e) => e.tid == todo.tid);
      scheduleList.refresh();
    } catch (e) {
      return;
    } finally {
      onLoading.value = false;
    }
  }

  void editTodoTitle({required Schedule schedule, required Todo todo}) async {
    editingScheduleIndex.value = scheduleList.indexOf(schedule);
    editingTodoIndex.value = scheduleList[scheduleList.indexOf(schedule)].todoList.indexOf(todo);
    todoEditingController.text = todo.todoTitle;
  }

  void updateTodoTitle({required Schedule schedule, required Todo todo}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      if (todoEditingController.value.text == todo.todoTitle) return;
      if (todoEditingController.value.text.isEmpty) {
        removeTodo(schedule: schedule, todo: todo);
        return;
      }
      Todo newTodo = Todo(
          tid: todo.tid,
          todoTitle: todoEditingController.value.text,
          todoStatus: todo.todoStatus,
          todoUpdatedAt: todo.todoUpdatedAt,
      );
      final Todo updated = await todoRepository.updateTodo(todo: newTodo);
      scheduleList[editingScheduleIndex.value!].todoList[editingTodoIndex.value!] = updated;
    } catch (e) {
      return;
    } finally {
      resetTextFormField();
      scheduleList.refresh();
      onLoading.value = false;
    }
  }

  void showTodoInputForm({required Schedule schedule}) async {
    onCreateTodo.value = true;
    editingScheduleIndex.value = scheduleList.indexOf(schedule);
    todoEditingController.text = "";
  }

  void createTodo({required Schedule schedule}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      if (todoEditingController.value.text.isEmpty) return;
      final Todo newTodo = Todo(
          tid: "",
          todoTitle: todoEditingController.value.text,
          todoStatus: TodoStatus.notStarted,
          todoUpdatedAt: DateTime.now(),
      );
      final Todo result = await todoRepository.createTodo(sid: schedule.sid, todo: newTodo);
      scheduleList[editingScheduleIndex.value!].todoList.add(result);
      scheduleList.refresh();
    } finally {
      resetTextFormField();
      onLoading.value = false;
    }
  }

  void showCategorySelectDialog() async {
    // TODO : 카테고리 선택 다이얼로그 열기
    TodoLabel? todoLabel = await Get.bottomSheet(
      SelectTodoLabelDialogView.route(),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as TodoLabel?;
  }
}
