import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/Schedule.dart';

const dayList = ['일', '월', '화', '수', '목', '금', '토'];

class CreateScheduleController extends GetxController {
  final Schedule schedule;
  final bool isNew;
  static CreateScheduleController to = Get.find();

  CreateScheduleController({required this.schedule, required this.isNew});

  double? y;

  final Rx<bool> onLoading = RxBool(true);
  final RxBool onEditing = RxBool(false);
  final RxnString location = RxnString(null);
  final RxnString detail = RxnString(null);
  final RxList<String> memberList = RxList([]);

  /// Uneditable Fields - DateTime
  String get selectedDateText => '${schedule.scheduleDate.year}년 '
      '${schedule.scheduleDate.month}월 '
      '${schedule.scheduleDate.day}일 '
      '(${dayList[schedule.scheduleDate.weekday % 7]})';

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
    titleController.text = schedule.scheduleTitle;
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

  void cancelSchedule() {
    // TODO : [Feat] Alert that If Cancel on Editing, All Edited Value will be Removed
    Get.back();
  }

  void removeSchedule() async {
    // TODO : [Feat] Alert to Confirm to Remove
    // TODO : [Feat] Connect Repository to Remove Schedule on DB
    Get.back();
  }

  void saveSchedule() async {
    try {
      final Schedule newSchedule = Schedule(
        scheduleId: schedule.scheduleId,
        scheduleDate: schedule.scheduleDate,
        scheduleIndexList: schedule.scheduleIndexList,
        scheduleColorHex: schedule.scheduleColorHex,
        scheduleTitle: titleController.value.text.isEmpty ? '제목 없음' : titleController.value.text,
        scheduleMember: memberList.toList(),
        scheduleDone: false,
      );
      // TODO : [Feat] Connect Repository to Create Or Update Schedule on DB
      Get.back(
        result: newSchedule,
      );
    } catch (e) {
      print("업로드 실패. 다시시도");
    }
  }

  /// Schedule Editor
  void addContent() async {
    // TODO : [Feat] Create Function to Add Content
  }

  void addMember() {
    if (memberController.value.text.isEmpty) return;
    memberList.add(memberController.value.text);
    memberController.clear();
  }

  void showMemberInfo(int index) async {
    bool? removed = await Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Text(
                  memberList[index],
                  style: StyledFont.BODY,
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => removeMember(index),
                  child: const Text('삭제', style: StyledFont.CALLOUT_NEGATIVE),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void removeMember(int index) {
    memberList.removeAt(index);
    memberList.refresh();
    Get.back();
  }
}
