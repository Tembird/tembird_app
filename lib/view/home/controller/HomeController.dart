import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/model/ScheduledIndex.dart';
import 'package:tembird_app/repository/DailyTodoRepository.dart';
import 'package:tembird_app/repository/InitRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/dialog/todo/detail/DetailTodoDialogView.dart';
import 'package:tembird_app/view/dialog/todo/detail/argument/DetailTodoDialogArgument.dart';
import 'package:tembird_app/view/dialog/todo/edit/EditTodoDialogView.dart';
import 'package:tembird_app/view/dialog/todoLabel/select/SelectTodoLabelDialogView.dart';
import 'package:tembird_app/view/help/main/HelpView.dart';
import '../../../model/CellStyle.dart';
import '../../../model/DailyTodo.dart';
import '../../../model/ModalAction.dart';
import '../../dialog/calendar/CalendarView.dart';
import '../../dialog/todo/select/SelectTodoDialogView.dart';

class HomeController extends RootController with GetSingleTickerProviderStateMixin {
  final DailyTodoRepository dailyTodoRepository = DailyTodoRepository();
  final InitRepository initRepository = InitRepository();
  TabController? tabController;
  double? x;

  static HomeController to = Get.find();
  final RxInt viewIndex = RxInt(0);
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");
  final Rx<bool> onLoading = RxBool(false);

  final RxList<DailyTodoLabel> dailyTodoLabelList = RxList([]);

  final Rxn<int> editingDailyTodoLabelIndex = Rxn(null);
  final Rxn<int> editingDailyTodoIndex = Rxn(null);
  final TextEditingController todoEditingController = TextEditingController();

  @override
  void onInit() async {
    selectedDateText.value = dateToString(date: selectedDate.value);
    tabController = TabController(vsync: this, length: 2);
    await getAllDailyTodoList(date: selectedDate.value);
    super.onInit();
  }

  @override
  void onClose() {
    tabController!.dispose();
    todoEditingController.dispose();
    super.onClose();
  }

  void resetTextFormField() {
    editingDailyTodoLabelIndex.value = null;
    editingDailyTodoIndex.value = null;
  }

  void dragHorizontalStart(double start) {
    x = start;
  }

  void dragHorizontalCancel() {
    x = null;
  }

  void dragHorizontalUpdate(double current) async {
    if (x == null) return;

    if (current < (x! + 80) && current > (x! - 80)) {
      return;
    }
    double startX = x!;
    x = null;
    DateTime? newDate;

    if (current > (startX + 80)) {
      newDate = selectedDate.value.subtract(const Duration(days: 1));
    }
    if (current < (startX - 80)) {
      newDate = selectedDate.value.add(const Duration(days: 1));
    }

    if (newDate == null) return;

    selectedDate.value = newDate;
    selectedDateText.value = dateToString(date: newDate);
    await getAllDailyTodoList(date: newDate);
  }

  Future<void> getAllDailyTodoList({required DateTime date}) async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      dailyTodoLabelList.clear();
      List<DailyTodoLabel> list = await dailyTodoRepository.readDailyTodoByDate(date: dateToInt(date: date));
      dailyTodoLabelList.addAll(list);
      refreshScheduledIndexList();
      refreshCellStyleList();
    } finally {
      dailyTodoLabelList.refresh();
      onLoading.value = false;
    }
  }

  void refreshScheduledIndexList() {
    scheduledIndexList.clear();
    for (var dailyTodoLabel in dailyTodoLabelList) {
      for (var dailyTodo in dailyTodoLabel.todoList) {
        if (dailyTodo.startAt == null || dailyTodo.endAt == null) continue;
        for (int i = dailyTodo.startAt!; i < dailyTodo.endAt! + 1; i++) {
          scheduledIndexList.add(ScheduledIndex(index: i, dailyTodoLabelId: dailyTodoLabel.id, dailyTodoId: dailyTodo.id));
        }
      }
    }
    scheduledIndexList.sort((a, b) => a.index.compareTo(b.index));
  }

  void selectView(int index) {
    if (viewIndex.value == index) return;
    if (viewIndex.value == 0) {
      resetTextFormField();
    }
    viewIndex.value = index;
  }

  void updateDailyTodoDuration(List<int> indexList) async {
    ActionResult? updated = await Get.dialog(
      SelectTodoDialogView.route(dailyTodoLabelList: dailyTodoLabelList, startAt: indexList.first, endAt: indexList.last),
    ) as ActionResult?;

    if (updated == null) return;

    dailyTodoLabelList[updated.dailyTodoLabelIndex!].todoList[updated.dailyTodoIndex!].startAt = indexList.first;
    dailyTodoLabelList[updated.dailyTodoLabelIndex!].todoList[updated.dailyTodoIndex!].endAt = indexList.last;
    dailyTodoLabelList.refresh();
    refreshScheduledIndexList();
    refreshCellStyleList();

    startIndex.value = null;
    endIndex.value = null;
    selectedIndexList.clear();
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
    selectedDate.value = newDate;
    selectedDateText.value = dateToString(date: newDate);
    await getAllDailyTodoList(date: newDate);
  }

  void openHelpView() {
    resetTextFormField();
    Get.toNamed(HelpView.routeName);
  }

  /// HomeScheduleTable
  List<ScheduledIndex> scheduledIndexList = [];

  List<int> selectedIndexList = [];
  Rxn<int> startIndex = Rxn(null);
  Rxn<int> endIndex = Rxn(null);

  final double tableWidth = Get.width < 500 ? Get.width : (Get.width / 2);
  final double cellWidth = ((Get.width < 500 ? Get.width : (Get.width / 2)) - 32) / 6;
  final double cellHeight = 45;
  final RxList<CellStyle> cellStyleList = RxList(List.generate(144, (index) => CellStyle(length: 1)));

  void onTableTapDown(TapDownDetails details) async {
    int selectedIndex = getIndexFromPosition(details.localPosition);
    if (selectedIndexList.contains(selectedIndex)) {
      updateDailyTodoDuration(selectedIndexList);
      return;
    }
    if (endIndex.value != null) {
      startIndex.value = null;
      endIndex.value = null;
      selectedIndexList.clear();
      return;
    }
    ScheduledIndex? scheduledIndex = scheduledIndexList.firstWhereOrNull((e) => e.index == selectedIndex);
    if (scheduledIndex == null) return;

    int dailyTodoLabelIndex = dailyTodoLabelList.indexWhere((e) => e.id == scheduledIndex.dailyTodoLabelId);
    int dailyTodoIndex = dailyTodoLabelList[dailyTodoLabelIndex].todoList.indexWhere((e) => e.id == scheduledIndex.dailyTodoId);
    openDailyTodoDetailDialog(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
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
    if (scheduledIndexList.any((e) => e.index >= startIndex.value! && e.index <= endIndex.value!)) {
      startIndex.value = null;
      endIndex.value = null;
      showAlertDialog(message: '선택하신 시간에 이미 일정이 있습니다\n기존 일정을 삭제하신 후 다시 시도해주세요');
      return;
    }
    selectedIndexList.clear();
    selectedIndexList.addAll(List.generate(endIndex.value! - startIndex.value! + 1, (index) => startIndex.value! + index));
  }

  ScheduledIndex? getScheduledIndex(int index) {
    return scheduledIndexList.firstWhereOrNull((e) => e.index == index);
  }

  int getIndexFromPosition(Offset position) {
    final int x = position.dx ~/ cellWidth;
    final int y = position.dy ~/ cellHeight;
    return (x + 6 * y);
  }

  void refreshCellStyleList() async {
    startIndex.value = null;
    endIndex.value = null;
    selectedIndexList.clear();

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

      ScheduledIndex? scheduledIndex = getScheduledIndex(index);
      if (scheduledIndex == null) {
        cellStyleList.add(CellStyle(length: 1));
        continue;
      }

      DailyTodoLabel dailyTodoLabel = dailyTodoLabelList.firstWhere((e) => e.id == scheduledIndex.dailyTodoLabelId);
      DailyTodo dailyTodo = dailyTodoLabel.todoList.firstWhere((e) => e.id == scheduledIndex.dailyTodoId);

      span = dailyTodo.endAt! - dailyTodo.startAt! + 1;
      columnSpan = dailyTodo.endAt! ~/ 6 == dailyTodo.startAt! ~/ 6 ? span : 6 - dailyTodo.startAt! % 6;
      scheduleColor = Color(int.parse(dailyTodoLabel.colorHex, radix: 16) + 0xFF000000);
      bool isTitleOnFirstLine = columnSpan > 3 || columnSpan + 1 > span - columnSpan;
      title = dailyTodo.title;
      cellStyleList.add(CellStyle(length: columnSpan, text: isTitleOnFirstLine ? title : null, color: scheduleColor));
      columnSpan--;
      span--;
      if (isTitleOnFirstLine) {
        title = null;
      }
    }
  }

  /// HomeTodoList
  void onDone({required int dailyTodoLabelIndex, required int dailyTodoIndex}) {
    updateDailyTodoStatus(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex, updatedStatus: TodoStatus.done);
  }

  void onNotStated({required int dailyTodoLabelIndex, required int dailyTodoIndex}) {
    updateDailyTodoStatus(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex, updatedStatus: TodoStatus.notStarted);
  }

  void onPass({required int dailyTodoLabelIndex, required int dailyTodoIndex}) {
    updateDailyTodoStatus(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex, updatedStatus: TodoStatus.pass);
  }

  void updateDailyTodoStatus({required int dailyTodoLabelIndex, required int dailyTodoIndex, required int updatedStatus}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      resetTextFormField();
      await dailyTodoRepository.updateDailyTodoStatus(id: dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].id, status: updatedStatus);
      dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].status = updatedStatus;
      dailyTodoLabelList.refresh();
    } finally {
      onLoading.value = false;
    }
  }

  void openDailyTodoDetailDialog({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    DailyTodoLabel dailyTodoLabel = dailyTodoLabelList[dailyTodoLabelIndex];
    DailyTodo dailyTodo = dailyTodoLabel.todoList[dailyTodoIndex];
    DetailTodoDialogArgument argument = DetailTodoDialogArgument(
      date: selectedDate.value,
      todoLabel: dailyTodoLabel,
      todo: dailyTodo,
    );
    bool? isShowTodoActionModal = await Get.dialog(
      DetailTodoDialogView.route(argument: argument),
    );
    if (isShowTodoActionModal == null || !isShowTodoActionModal) return;
    showTodoActionModal(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
  }

  void showTodoActionModal({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    resetTextFormField();
    final List<ModalAction> modalActionList = [
      ModalAction(name: '수정하기', onPressed: () => Get.back(result: 0), isNegative: false),
      ModalAction(name: '삭제하기', onPressed: () => Get.back(result: 1), isNegative: false),
      ModalAction(name: '시간 삭제하기', onPressed: () => Get.back(result: 2), isNegative: false),
    ];
    int? action = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: '수정 및 삭제',
    );
    if (action == null) return;
    if (action == 0) {
      editDailyTodo(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
      return;
    }
    if (action == 1) {
      removeDailyTodo(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
      return;
    }
    if (action == 2) {
      removeDailyTodoDuration(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
      return;
    }
  }

  void removeDailyTodo({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    try {
      await dailyTodoRepository.deleteDailyTodo(id: dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].id);
      dailyTodoLabelList[dailyTodoLabelIndex].todoList.removeAt(dailyTodoIndex);
      if (dailyTodoLabelList[dailyTodoLabelIndex].todoList.isNotEmpty) return;
      dailyTodoLabelList.removeAt(dailyTodoLabelIndex);
    } catch (e) {
      return;
    } finally {
      dailyTodoLabelList.refresh();
      refreshScheduledIndexList();
      refreshCellStyleList();
    }
  }

  void removeDailyTodoDuration({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    try {
      await dailyTodoRepository.deleteDailyTodoDuration(id: dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].id);
      dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].startAt = null;
      dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].endAt = null;
    } finally {
      dailyTodoLabelList.refresh();
      refreshScheduledIndexList();
      refreshCellStyleList();
    }
  }

  void selectDailyTodoTitle({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    editingDailyTodoLabelIndex.value = dailyTodoLabelIndex;
    editingDailyTodoIndex.value = dailyTodoIndex;
    todoEditingController.text = dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].title;
  }

  void updateDailyTodoTitle({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      DailyTodo selectedDailyTodo = dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex];
      if (todoEditingController.value.text == selectedDailyTodo.title) return;
      if (todoEditingController.value.text.isEmpty) {
        removeDailyTodo(dailyTodoLabelIndex: dailyTodoLabelIndex, dailyTodoIndex: dailyTodoIndex);
        return;
      }
      await dailyTodoRepository.updateDailyTodoInfo(
        id: selectedDailyTodo.id,
        title: todoEditingController.value.text,
        location: selectedDailyTodo.location,
        detail: selectedDailyTodo.detail,
      );
      selectedDailyTodo.title = todoEditingController.value.text;
    } catch (e) {
      return;
    } finally {
      resetTextFormField();
      dailyTodoLabelList.refresh();
      refreshCellStyleList();
      onLoading.value = false;
    }
  }

  void createDailyTodoAndLabel() async {
    DailyTodoLabel? dailyTodoLabel = await Get.bottomSheet(
      SelectTodoLabelDialogView.route(date: selectedDate.value),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as DailyTodoLabel?;

    if (dailyTodoLabel == null) return;

    final DailyTodoLabel? existDailyTodoLabel = dailyTodoLabelList.firstWhereOrNull((e) => e.date == dailyTodoLabel.date && e.labelId == dailyTodoLabel.labelId);

    ActionResult? actionResult = await Get.bottomSheet(
      EditTodoDialogView.route(isNew: true, hasLabel: existDailyTodoLabel != null, initDailyTodoLabel: existDailyTodoLabel ?? dailyTodoLabel),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as ActionResult?;

    if (actionResult == null || actionResult.action != ActionResultType.created) return;

    if (existDailyTodoLabel == null) {
      dailyTodoLabelList.add(actionResult.dailyTodoLabel!);
    }
    dailyTodoLabelList.refresh();
  }

  void createDailyTodo({required int index}) async {
    ActionResult? actionResult = await Get.bottomSheet(
      EditTodoDialogView.route(isNew: true, hasLabel: true, initDailyTodoLabel: dailyTodoLabelList[index]),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as ActionResult?;

    if (actionResult == null || actionResult.action != ActionResultType.created) return;

    dailyTodoLabelList.refresh();
  }

  void editDailyTodo({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    DailyTodoLabel dailyTodoLabel = dailyTodoLabelList[dailyTodoLabelIndex];
    DailyTodo dailyTodo = dailyTodoLabel.todoList[dailyTodoIndex];
    ActionResult? actionResult = await Get.bottomSheet(
      EditTodoDialogView.route(isNew: false, hasLabel: true, initDailyTodoLabel: dailyTodoLabel, initDailyTodo: dailyTodo),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as ActionResult?;

    if (actionResult == null || actionResult.action == ActionResultType.created) return;

    dailyTodoLabelList.refresh();
    refreshCellStyleList();
  }
}
