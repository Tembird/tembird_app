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

  Future<Schedule> createSchedule({required Schedule schedule}) async {
    final Response response = await post('/schedule', schedule.toJson());
    if (response.hasError) {
      errorHandler(response);
    }
    Schedule result = Schedule.fromJson(response.body['body']);
    return result;
  }

  Future<Schedule> updateSchedule({required Schedule schedule, required List<String> removedTidList}) async {
    Map<String, dynamic> data = schedule.toJson();
    data.addAll({'removedTidList':removedTidList});
    final Response response = await put('/schedule', data);
    if (response.hasError) {
      errorHandler(response);
    }
    Schedule result = Schedule.fromJson(response.body['body']);
    return result;
  }

  Future<void> deleteSchedule({required Schedule schedule}) async {
    final Response response = await delete('/schedule/${schedule.sid}');
    if (response.hasError) {
      errorHandler(response);
    }
  }
}