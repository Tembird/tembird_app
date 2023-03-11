import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/calendar/CalendarView.dart';
import '../../../model/Schedule.dart';
import '../../create/schedule/CreateScheduleView.dart';

class HomeController extends RootController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  static HomeController to = Get.find();

  final RxInt viewIndex = RxInt(0);

  final RxList<Schedule> scheduleList = RxList([]);
  final Rx<bool> onLoading = RxBool(true);
  final Rx<bool> onBottomSheet = RxBool(true);

  final Rx<bool> isSelecting = RxBool(false);
  Set<int> previousSelectedIndexList = {};

  /// Select Schedule
  final Rx<DateTime> selectedDate = Rx(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  final Rx<String> selectedDateText = Rx("");

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
    // TODO : Connect Repository to get Schedule List in SelectedDate
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

    bool? isChanged = await Get.bottomSheet(
      CreateScheduleView.route(schedule, false),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as bool?;

    if (isChanged == null) return;
    await getScheduleList();
  }

  void showScheduleDetail(Schedule schedule) async {
    bool? isChanged = await Get.bottomSheet(
      CreateScheduleView.route(schedule, false),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as bool?;

    if (isChanged == null) return;
    await getScheduleList();
  }

  void changeScheduleStatus(Schedule schedule) async {
    print("=========> changeScheduleStatus");
    // TODO : Connect Repository to Change Status of Schedule
    await getScheduleList();
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
    selectedDate.value = newDate;
    selectedDateText.value = dateToString(date: newDate);
    await getScheduleList();
  }
}
