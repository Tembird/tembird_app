import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/ModalAction.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/model/Todo.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/service/SessionService.dart';
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
    selectedScheduleTimeText = '${schedule.startAt ~/ 6}시 ${schedule.startAt % 6 * 10}분 ~ '
        '${schedule.endAt ~/ 6}시 ${schedule.endAt % 6 * 10 + 10}분 '
        '(${schedule.scheduleIndexList.length * 10}분)';
    scheduleDone.value = schedule.done;
    scheduleColorHex.value = schedule.colorHex;
    todoList.addAll(schedule.todoList);

    if (schedule.title != null) {
      titleController.text = schedule.title!;
    }
    // if (schedule.todoList.isNotEmpty) {
    //   todoList.addAll(schedule.todoList);
    //   hasTodo.value = true;
    // }
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
    try {
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
    }
  }

  void saveSchedule() async {
    try {
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
    }
  }

  void createResultSchedule() {
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

  void removeTodo(int index) {
    onEdit();
    if (todoList[index].tid.isNotEmpty) {
      removedTidList.add(todoList[index].tid);
    }
    todoList.removeAt(index);
    todoList.refresh();
    Get.back();
  }

  void showTodoInfo(int index) async {
    final List<ModalAction> modalActionList = [
      ModalAction(name: '삭제', onPressed: () => removeTodo(index), isNegative: true),
    ];
    await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: todoList[index].todoTitle,
    );
  }
}
