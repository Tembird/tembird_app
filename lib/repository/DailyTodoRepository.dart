import 'package:get/get.dart';
import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class DailyTodoRepository extends RootRepository {
  static DailyTodoRepository to = Get.find();

  DailyTodoRepository() {
    initialization();
  }

  Future<DailyTodo> createDailyTodo({required String title, required int dailyLabelId, required String? location, required String? detail}) async {
    Map<String, dynamic> data = {
      'title':title,
      'dailyLabelId':dailyLabelId,
      'location':location,
      'detail':detail,
    };
    final Response response = await post('/daily/todo', data);
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodo result = DailyTodo.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodo> readDailyTodo({required int id}) async {
    final Response response = await get('/daily/todo/$id');
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodo result = DailyTodo.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodoLabel> readDailyTodoByDate({required int date}) async {
    final Response response = await get('/daily/todo?date=$date');
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodoLabel result = DailyTodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodoLabel> readDailyTodoByDailyTodoLabel({required int dailyLabelId}) async {
    final Response response = await get('/daily/todo?dailyLabelId=$dailyLabelId');
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodoLabel result = DailyTodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodo> updateDailyTodoInfo({required int id, required String title, required String? location, required String? detail}) async {
    Map<String, dynamic> data = {
      "id":id,
      "title":title,
      'location':location,
      'detail':detail,
    };
    final Response response = await patch('/daily/todo', data);
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodo result = DailyTodo.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodo> updateDailyTodoStatus({required int id, required int status}) async {
    Map<String, dynamic> data = {
      "id":id,
      "status":status
    };
    final Response response = await patch('/daily/todo', data);
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodo result = DailyTodo.fromJson(response.body['body']);
    return result;
  }

  Future<DailyTodo> updateDailyTodoDuration({required int id, required int startAt, required int endAt}) async {
    Map<String, dynamic> data = {
      "id":id,
      "startAt":startAt,
      "endAt":endAt,
    };
    final Response response = await patch('/daily/todo', data);
    if (response.hasError) {
      errorHandler(response);
    }
    DailyTodo result = DailyTodo.fromJson(response.body['body']);
    return result;
  }

  Future<void> deleteDailyTodo({required int id}) async {
    final Response response = await delete('/daily/todo/$id');
    if (response.hasError) {
      errorHandler(response);
    }
  }
}