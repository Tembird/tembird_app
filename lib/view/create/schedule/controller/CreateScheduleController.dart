import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:tembird_app/model/ModalAction.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/model/Todo.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

import '../../../../model/ScheduleAction.dart';

class CreateScheduleController extends RootController {
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  final List<String> scheduleColorHexList = HomeController.to.scheduleColorHexList;
  final Schedule schedule;
  late final String selectedDateText;
  late final String selectedScheduleTimeText;
  final bool isNew;
  static CreateScheduleController to = Get.find();

  CreateScheduleController({required this.schedule, required this.isNew});

  double? y;

  final Rx<bool> onLoading = RxBool(true);
  final RxBool onEditing = RxBool(false);
  final RxBool scheduleDone = RxBool(false);
  final RxString scheduleColorHex = RxString('000000');
  final Rxn<Schedule> resultSchedule = Rxn(null);
  final RxnString location = RxnString(null);
  final RxnString detail = RxnString(null);
  final RxList<Todo> todoList = RxList([]);
  final Rxn<int> editingTodoIndex = Rxn(null);
  final TextEditingController todoEditingController = TextEditingController();

  /// Editable Fields - Title, Location, MemberList, Detail
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController todoController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  List<String> removedTidList = [];

  // final RxBool hasTodo = RxBool(false);
  final RxBool hasLocation = RxBool(false);
  final RxBool hasDetail = RxBool(false);

  /// Controller Create / Remove
  @override
  void onInit() async {
    onLoading.value = true;
    selectedDateText = dateToString(date: schedule.date);
    selectedScheduleTimeText = '${indexToTimeString(index: schedule.startAt)} ~ ${indexToTimeString(index: schedule.endAt)} '
        '(${schedule.scheduleIndexList.length * 10}분)';
    scheduleDone.value = schedule.done;
    scheduleColorHex.value = schedule.colorHex;
    todoList.addAll(schedule.todoList);

    if (schedule.title != null) {
      titleController.text = schedule.title!;
    }
    if (schedule.location != null) {
      locationController.text = schedule.location!;
      hasLocation.value = true;
    }
    if (schedule.detail != null) {
      detailController.text = schedule.detail!;
      hasDetail.value = true;
    }
    super.onInit();
    onLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    todoController.dispose();
    detailController.dispose();
    todoEditingController.dispose();
    super.onClose();
  }

  /// BottomSheet
  void onEdit() {
    if (onEditing.isTrue) return;
    onEditing.value = true;
  }

  void dragStart(double start) {
    y = start;
  }

  void dragCancel() {
    y = null;
  }

  void dragUpdate(double current) {
    if (y == null || current < (y! + 30)) return;
    cancelSchedule();
  }

  /// Ads
  void tapAds() {
    // TODO : [Feat] Link to Advertisement
    print('=======> Show Ads');
  }

  void cancelSchedule() async {
    createResultSchedule();

    if (resultSchedule.value == null) {
      Get.back();
      return;
    }

    final List<ModalAction> modalActionList = [
      ModalAction(name: '확인', onPressed: () => Get.back(result: true), isNegative: false),
    ];
    bool? isConfirmed = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: '변경 사항이 모두 삭제됩니다',
    );
    if (isConfirmed == null) return;
    Get.back();
  }

  void removeSchedule() async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      final List<ModalAction> modalActionList = [
        ModalAction(name: '삭제', onPressed: () => Get.back(result: true), isNegative: true),
      ];
      bool? isConfirmed = await showCupertinoActionSheet(
        modalActionList: modalActionList,
        title: '일정이 삭제됩니다',
      );
      if (isConfirmed == null) return;
      await scheduleRepository.deleteSchedule(schedule: schedule);
      Get.back(result: ScheduleAction(action: ActionType.removed));
    } catch(e) {
      Get.back();
      return;
    } finally {
      onLoading.value = false;
    }
  }

  void saveSchedule() async {
    if (onLoading.value == true) return;
    try {
      onLoading.value = true;
      createResultSchedule();

      if (resultSchedule.value == null) {
        Get.back();
        return;
      }

      Schedule? result;
      if (isNew) {
        result = await scheduleRepository.createSchedule(schedule: resultSchedule.value!);
      } else {
        result = await scheduleRepository.updateSchedule(schedule: resultSchedule.value!,removedTidList:removedTidList);
        removedTidList.clear();
      }

      Get.back(
        result: ScheduleAction(
          action: isNew ? ActionType.created : ActionType.updated,
          schedule: result,
        ),
      );
    } catch (e) {
      print(e);
      Get.back();
      return;
    } finally {
      onLoading.value = false;
    }
  }

  void createResultSchedule() {
    if (editingTodoIndex.value != null) {
      updateTodoTitle(index: editingTodoIndex.value!);
    }
    final Schedule newSchedule = Schedule(
      sid: schedule.sid,
      date: schedule.date,
      scheduleIndexList: schedule.scheduleIndexList,
      startAt: schedule.scheduleIndexList.first,
      endAt: schedule.scheduleIndexList.last,
      colorHex: scheduleColorHex.value,
      title: titleController.value.text.isEmpty ? null : titleController.value.text,
      location: locationController.value.text.isEmpty ? null : locationController.value.text,
      detail: detailController.value.text.isEmpty ? null : detailController.value.text,
      done: scheduleDone.isTrue,
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
      todoList: todoList,
    );

    Function deepEq = const DeepCollectionEquality().equals;

    bool isChanged = newSchedule.title != schedule.title ||
        newSchedule.location != schedule.location ||
        !deepEq(newSchedule.todoList, schedule.todoList) ||
        newSchedule.detail != schedule.detail ||
        newSchedule.colorHex != schedule.colorHex ||
        newSchedule.done != schedule.done;

    if (!isChanged) {
      resultSchedule.value = null;
      return;
    }

    resultSchedule.value = newSchedule;
  }

  /// Schedule Editor
  void changeStatus() async {
    scheduleDone.value = !scheduleDone.value;
  }

  void changeColorHex(String colorHexCode) async {
    scheduleColorHex.value = colorHexCode;
  }

  void addContent() async {
    final List<ModalAction> modalActionList = [
      if (hasLocation.isFalse) ModalAction(name: '장소 추가', onPressed: addLocationForm, isNegative: false),
      if (hasDetail.isFalse) ModalAction(name: '상세 내용 추가', onPressed: addDetailForm, isNegative: false),
    ];
    await showCupertinoActionSheet(
        modalActionList: modalActionList,
        title: '다음 항목을 추가할 수 있습니다'
    );
  }

  void addLocationForm() {
    hasLocation.value = true;
    Get.back();
  }

  void addDetailForm() {
    hasDetail.value = true;
    Get.back();
  }

  void addTodo() {
    if (todoController.value.text.isEmpty) return;
    todoList.add(Todo(tid: "", todoTitle: todoController.value.text, todoStatus: TodoStatus.notStarted, todoUpdatedAt: DateTime.now()));
    todoController.clear();
  }

  void onTodoDone({required int index}) {
    Todo previous = todoList[index];
    todoList[index] = Todo(
        tid: previous.tid,
        todoTitle: previous.todoTitle,
        todoStatus: TodoStatus.done,
        todoUpdatedAt: previous.todoUpdatedAt,
    );
    todoList.refresh();
  }

  void onTodoNotStated({required int index}) {
    Todo previous = todoList[index];
    todoList[index] = Todo(
      tid: previous.tid,
      todoTitle: previous.todoTitle,
      todoStatus: TodoStatus.notStarted,
      todoUpdatedAt: previous.todoUpdatedAt,
    );
    todoList.refresh();
  }

  void onTodoPass({required int index}) {
    Todo previous = todoList[index];
    todoList[index] = Todo(
      tid: previous.tid,
      todoTitle: previous.todoTitle,
      todoStatus: TodoStatus.pass,
      todoUpdatedAt: previous.todoUpdatedAt,
    );
    todoList.refresh();
  }

  void showTodoActionModal({required int index}) async {
    onEdit();
    resetTextFormField();
    final List<ModalAction> modalActionList = [
      ModalAction(name: '수정하기', onPressed: () => Get.back(result: 0), isNegative: false),
      ModalAction(name: '삭제하기', onPressed: () => Get.back(result: 1), isNegative: false),
    ];
    int? action = await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: todoList[index].todoTitle,
    );
    if (action == null) return;
    if (action == 0) {
      editTodoTitle(index: index);
      return;
    }
    if (action == 1) {
      removeTodo(index: index);
      return;
    }
  }

  void editTodoTitle({required int index}) async {
    editingTodoIndex.value = index;
    todoEditingController.text = todoList[index].todoTitle;
  }

  void updateTodoTitle({required int index}) async {
    try {
      onLoading.value = true;
      Todo todo = todoList[index];
      if (todoEditingController.value.text == todo.todoTitle) return;
      if (todoEditingController.value.text.isEmpty) {
        removeTodo(index: index);
        return;
      }
      Todo newTodo = Todo(
        tid: todo.tid,
        todoTitle: todoEditingController.value.text,
        todoStatus: todo.todoStatus,
        todoUpdatedAt: todo.todoUpdatedAt,
      );
      todoList[index] = newTodo;
    } catch (e) {
      return;
    } finally {
      resetTextFormField();
      onLoading.value = false;
    }
  }

  void removeTodo({required int index}) {
    onEdit();
    if (todoList[index].tid.isNotEmpty) {
      removedTidList.add(todoList[index].tid);
    }
    todoList.removeAt(index);
    todoList.refresh();
  }

  void resetTextFormField() {
    todoController.text = "";
    editingTodoIndex.value = null;
    hideKeyboard();
  }
}
