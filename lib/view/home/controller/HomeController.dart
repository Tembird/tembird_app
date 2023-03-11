import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/PageNames.dart';
import '../../../model/Schedule.dart';
import '../../create/schedule/CreateScheduleView.dart';

const dayList = ['일', '월', '화', '수', '목', '금', '토'];

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  static HomeController to = Get.find();

  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);

  final Rx<bool> isSelecting = RxBool(false);
  Set<int> previousSelectedIndexList = {};

  /// Select Schedule
  final Rxn<Schedule> selectedSchedule = Rxn(null);
  final Rx<DateTime> selectedDate = Rx(DateTime.now());
  final Rx<String> selectedDateText = Rx("");
  int selectedScheduleStartAt = 0;
  int selectedScheduleEndAt = 0;

  String get selectedScheduleTimeText =>
      '${selectedScheduleStartAt ~/ 6 + 4}시 ${selectedScheduleStartAt % 6 * 10}분 ~ ${selectedScheduleEndAt ~/ 6 + 4}시 ${selectedScheduleEndAt % 6 * 10 + 10}분 (${(selectedScheduleEndAt - selectedScheduleStartAt) * 10 + 10}분)';

  final RxBool onEditing = RxBool(false);

  /// Schedule Editor
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  @override
  void onInit() async {
    // EasyLoading.show
    onLoading.value = true;
    selectedDateText.value = dateToString(date: selectedDate.value);
    tabController = TabController(vsync: this, length: 2);
    await getScheduleList();
    super.onInit();
    onLoading.value = false;
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }

  Future<void> getScheduleList() async {
    scheduleList.clear();
    scheduleList.addAll([
      Schedule(
        scheduleId: 1,
        scheduleDate: DateTime(2023, 3, 10),
        scheduleIndexList: [13, 14, 15],
        scheduleColorHex: "859039",
        scheduleTitle: "코딩 공부",
        scheduleDetail: "DateTime 공부",
        scheduleDone: false,
        scheduleMember: [],
      ),
      Schedule(
        scheduleId: 1,
        scheduleDate: DateTime(2023, 3, 10),
        scheduleIndexList: [38, 39, 40, 41, 42, 43],
        scheduleColorHex: '77DD77',
        scheduleTitle: '코딩',
        scheduleDetail: 'DB 구축 회의\n짱구 - 모델 설계\n철수 - API 설계\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택 ',
        scheduleDone: false,
        scheduleMember: ['짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구', '철수', '맹구'],
        scheduleLocation: '서울',
      ),
    ]);
    scheduleList.refresh();
  }

  void createSchedule(List<int> indexList) async {
    final Schedule? schedule = await Get.toNamed(PageNames.CREATE, arguments: indexList) as Schedule?;
    if (schedule == null) return;

    await uploadSchedule(schedule: schedule);
    confirmSelection();
  }

  Future<void> selectSchedule({required Schedule schedule}) async {
    selectedSchedule.value = schedule;
    selectedDate.value = schedule.scheduleDate;
    selectedDateText.value = dateToString(date: schedule.scheduleDate);
    selectedScheduleStartAt = schedule.scheduleIndexList.first;
    selectedScheduleEndAt = schedule.scheduleIndexList.last;
    titleController.text = schedule.scheduleTitle;
  }

  void showScheduleDetail(Schedule schedule) async {
    await selectSchedule(schedule: schedule);
    bool? isChanged = await Get.bottomSheet(
      CreateScheduleView.route(schedule, false),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as bool?;

    if (isChanged == null) return;
    await getScheduleList();
  }

  Future<void> uploadSchedule({required Schedule schedule}) async {}

  void confirmSelection() {}

  String dateToString({required DateTime date}) {
    return '${date.year}년 ${date.month}월 ${date.day}일 (${dayList[date.weekday % 7]})';
  }

  /// BottomSheet
  void onTapBottomSheet() async {}

  void onEdit() {
    if (onEditing.isTrue) return;
    onEditing.value = true;
    print("======> onEditing");
  }

  void closeScheduleBottomSheet() {}

  void deleteSchedule() async {
    // TODO : [Feat] Create Function to Delete Schedule
  }

  void saveSchedule() async {
    // TODO : [Feat] Create Function to Save Schedule (Create, Update)
  }

  /// Schedule Editor
  void addContent() async {
    // TODO : [Feat] Create Function to Add Content
  }
}
