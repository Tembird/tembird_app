import 'package:get/get.dart';
import 'package:tembird_app/model/Schedule.dart';
import 'package:tembird_app/repository/RootRepository.dart';
import 'package:intl/intl.dart';

class ScheduleRepository extends RootRepository {
  static ScheduleRepository to = Get.find();

  ScheduleRepository() {
    initialization();
  }

  Future<List<Schedule>> readScheduleListOnDate({required DateTime dateTime}) async {
    List<Schedule> scheduleList = [];
    final String date = DateFormat('yyyyMMdd').format(dateTime);
    final Response response = await get('/schedule/$date');
    if (response.hasError) {
      errorHandler(response);
    }
    scheduleList = (response.body['body']['list'] as List).map((e) => Schedule.fromJson(e)).toList();
    return scheduleList;
  }

  Future<void> createSchedule({required Schedule schedule}) async {
    print('======> createSchedule');
    await Future.delayed(const Duration(seconds: 2));
    // TODO : Connect API to Create Schedule
  }

  Future<void> updateSchedule({required Schedule schedule}) async {
    print('======> updateSchedule');
    await Future.delayed(const Duration(seconds: 2));
    // TODO : Connect API to Update Schedule
  }

  Future<void> deleteSchedule({required Schedule schedule}) async {
    print('======> deleteSchedule');
    await Future.delayed(const Duration(seconds: 2));
    // TODO : Connect API to Delete Schedule
  }
}