import 'package:get/get.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class DailyTodoLabelRepository extends RootRepository {
  static DailyTodoLabelRepository to = Get.find();

  DailyTodoLabelRepository() {
    initialization();
  }

  Future<DailyTodoLabel> createDailyTodoLabel({required int date, required int labelId}) async {
    Map<String, dynamic> data = {
      'date': date,
      'labelId': labelId
    };

    final Response response = await post('/daily/todo/label', data);
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodoLabel result = DailyTodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodoLabel> readDailyTodoLabel({required int id}) async {
    final Response response = await get('/daily/todo/label/$id');
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodoLabel result = DailyTodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<List<DailyTodoLabel>> readDailyTodoLabelByDate({required int date}) async {
    final Response response = await get('/daily/todo/label?date=$date');
    if (response.hasError) {
      errorHandler(response);
    }
    List<DailyTodoLabel> result = (response.body['body'] as List).map((e) => DailyTodoLabel.fromJson(e)).toList();
    return result;
  }

  Future<void> deleteDailyTodoLabel({required int id}) async {
    final Response response = await delete('/daily/todo/label/$id');
    if (response.hasError) {
      errorHandler(response);
    }
  }
}