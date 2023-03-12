import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/model/ModalAction.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/repository/ScheduleRepository.dart';
import 'package:tembird_app/service/RootController.dart';

import '../../../../model/ScheduleAction.dart';

class CreateScheduleController extends RootController {
  final ScheduleRepository scheduleRepository = ScheduleRepository();
  final Schedule schedule;
  final bool isNew;
  static CreateScheduleController to = Get.find();

  CreateScheduleController({required this.schedule, required this.isNew});

  double? y;

  final Rx<bool> onLoading = RxBool(true);
  final RxBool onEditing = RxBool(false);
  final Rxn<Schedule> resultSchedule = Rxn(null);
  final RxnString location = RxnString(null);
  final RxnString detail = RxnString(null);
  final RxList<String> memberList = RxList([]);

  /// Uneditable Fields - DateTime
  String get selectedDateText => dateToString(date: schedule.scheduleDate);

  String get selectedScheduleTimeText => '${schedule.scheduleIndexList.first ~/ 6 + 4}시 ${schedule.scheduleIndexList.first % 6 * 10}분 ~ '
      '${schedule.scheduleIndexList.last ~/ 6 + 4}시 ${schedule.scheduleIndexList.last % 6 * 10 + 10}분 '
      '(${schedule.scheduleIndexList.length * 10}분)';

  /// Editable Fields - Title, Location, MemberList, Detail
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  final RxBool hasLocation = RxBool(false);
  final RxBool hasMember = RxBool(false);
  final RxBool hasDetail = RxBool(false);

  /// Controller Create / Remove
  @override
  void onInit() async {
    onLoading.value = true;
    if (schedule.scheduleTitle != null) {
      titleController.text = schedule.scheduleTitle!;
    }
    if (schedule.scheduleMember.isNotEmpty) {
      memberList.addAll(schedule.scheduleMember);
      hasMember.value = true;
    }
    if (schedule.scheduleLocation != null) {
      locationController.text = schedule.scheduleLocation!;
      hasLocation.value = true;
    }
    if (schedule.scheduleDetail != null) {
      detailController.text = schedule.scheduleDetail!;
      hasDetail.value = true;
    }
    super.onInit();
    onLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    memberController.dispose();
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

      if (isNew) {
        await scheduleRepository.createSchedule(schedule: resultSchedule.value!);
      } else {
        await scheduleRepository.updateSchedule(schedule: resultSchedule.value!);
      }

      Get.back(
        result: ScheduleAction(
          action: isNew ? ActionType.created : ActionType.updated,
          schedule: resultSchedule.value,
        ),
      );
    } catch (e) {
      Get.back();
      return;
    }
  }

  void createResultSchedule() {
    final Schedule newSchedule = Schedule(
      scheduleId: schedule.scheduleId,
      scheduleDate: schedule.scheduleDate,
      scheduleIndexList: schedule.scheduleIndexList,
      scheduleColorHex: schedule.scheduleColorHex,
      scheduleTitle: titleController.value.text.isEmpty ? null : titleController.value.text,
      scheduleLocation: locationController.value.text.isEmpty ? null : locationController.value.text,
      scheduleDetail: detailController.value.text.isEmpty ? null : detailController.value.text,
      scheduleMember: memberList.toList(),
      scheduleDone: schedule.scheduleDone,
    );

    bool isChanged = newSchedule.scheduleTitle != schedule.scheduleTitle ||
        newSchedule.scheduleLocation != schedule.scheduleLocation ||
        newSchedule.scheduleMember.toString() != schedule.scheduleMember.toString() ||
        newSchedule.scheduleDetail != schedule.scheduleDetail;

    if (!isChanged) {
      resultSchedule.value = null;
      return;
    }

    resultSchedule.value = newSchedule;
  }

  /// Schedule Editor
  void addContent() async {
    final List<ModalAction> modalActionList = [
      if (hasLocation.isFalse) ModalAction(name: '장소 추가', onPressed: addLocationForm, isNegative: false),
      if (hasMember.isFalse) ModalAction(name: '함께하는 사람 추가', onPressed: addMemberForm, isNegative: false),
      if (hasDetail.isFalse) ModalAction(name: '상세 내용 추가', onPressed: addDetailForm, isNegative: false),
    ];
    await showCupertinoActionSheet(
        modalActionList: modalActionList, title: hasMember.isFalse || hasLocation.isFalse || hasDetail.isFalse ? '다음 항목을 추가할 수 있습니다' : '모든 항목이 추가되어 있습니다');
  }

  void addLocationForm() {
    hasLocation.value = true;
    Get.back();
  }

  void addMemberForm() {
    hasMember.value = true;
    Get.back();
  }

  void addDetailForm() {
    hasDetail.value = true;
    Get.back();
  }

  void addMember() {
    if (memberController.value.text.isEmpty) return;
    memberList.add(memberController.value.text);
    memberController.clear();
  }

  void removeMember(int index) {
    onEdit();
    memberList.removeAt(index);
    memberList.refresh();
    Get.back();
  }

  void showMemberInfo(int index) async {
    final List<ModalAction> modalActionList = [
      ModalAction(name: '삭제', onPressed: () => removeMember(index), isNegative: true),
    ];
    await showCupertinoActionSheet(
      modalActionList: modalActionList,
      title: memberList[index],
    );
  }
}
