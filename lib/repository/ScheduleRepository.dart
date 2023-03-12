import 'package:get/get.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class ScheduleRepository extends RootRepository {
  static ScheduleRepository to = Get.find();

  Future<List<Schedule>> readScheduleListOnDate({required DateTime dateTime}) async {
    // TODO : Connect API to Read Schedule List on Date
    // await Future.delayed(const Duration(seconds: 2));

    List<Schedule> scheduleList = [];

    if (dateTime.isBefore(DateTime.now())) {
      scheduleList = [
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
          scheduleIndexList: [19, 20, 21, 22],
          scheduleColorHex: "859039",
          scheduleTitle: "코딩 공부",
          scheduleDetail: "DateTime 공부",
          scheduleDone: false,
          scheduleMember: [],
        ),
        Schedule(
          scheduleId: 1,
          scheduleDate: DateTime(2023, 3, 10),
          scheduleIndexList: [25, 26],
          scheduleColorHex: "859039",
          scheduleTitle: "코딩 공부",
          scheduleDetail: "DateTime 공부",
          scheduleDone: false,
          scheduleMember: [],
        ),
        Schedule(
          scheduleId: 2,
          scheduleDate: DateTime(2023, 3, 10),
          scheduleIndexList: [38, 39, 40, 41, 42, 43],
          scheduleColorHex: '77DD77',
          scheduleTitle: '코딩',
          scheduleDetail: 'DB 구축 회의\n짱구 - 모델 설계\n철수 - API 설계\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택\n맹구 - DB 및 서버 공급 서비스 선택 ',
          scheduleDone: false,
          scheduleMember: ['짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구', '철수', '맹구'],
          scheduleLocation: '서울',
        ),
      ];
    } else {
      scheduleList = [
        Schedule(
          scheduleId: 3,
          scheduleDate: DateTime(2023, 3, 15),
          scheduleIndexList: [13, 14, 15, 16, 17],
          scheduleColorHex: "859039",
          scheduleTitle: "디자인 미팅",
          scheduleDetail: "1. 홈 화면 UI 디자인 피드백\n2. 로고 디자인 요청",
          scheduleDone: false,
          scheduleMember: ['이히이'],
        ),
        Schedule(
          scheduleId: 4,
          scheduleDate: DateTime(2023, 3, 15),
          scheduleIndexList: [41, 42, 43],
          scheduleColorHex: '77DD77',
          scheduleTitle: '치과 진료',
          scheduleDone: false,
          scheduleMember: ['짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구짱구', '철수', '맹구'],
          scheduleLocation: '연세스마일치과',
        ),
      ];
    }

    return scheduleList;
  }

  Future<void> createSchedule({required Schedule schedule}) async {
    // TODO : Connect API to Create Schedule
  }

  Future<void> updateSchedule({required Schedule schedule}) async {
    // TODO : Connect API to Update Schedule
  }

  Future<void> deleteSchedule({required Schedule schedule}) async {
    // TODO : Connect API to Delete Schedule
  }
}