import 'package:get/get.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class TodoLabelRepository extends RootRepository {
  static TodoLabelRepository to = Get.find();

  TodoLabelRepository() {
    initialization();
  }

  Future<TodoLabel> createTodoLabel({required String title, required String colorHex}) async {
    Map<String, dynamic> data = {
      'title':title,
      'colorHex':colorHex,
    };
    final Response response = await post('/todo/label', data);
    if (response.hasError) {
      errorHandler(response);
    }
    TodoLabel result = TodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<List<TodoLabel>> readAllTodoLabel() async {
    final Response response = await get('/todo/label');
    if (response.hasError) {
      errorHandler(response);
    }
    List<TodoLabel> result = (response.body['body'] as List).map((e) => TodoLabel.fromJson(e)).toList();
    return result;
  }

  Future<TodoLabel> readTodoLabel({required int id}) async {
    final Response response = await get('/todo/label/$id');
    if (response.hasError) {
      errorHandler(response);
    }
    TodoLabel result = TodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<TodoLabel> updateTodo({required TodoLabel todoLabel}) async {
    final Response response = await put('/todo/label', todoLabel.toJson());
    if (response.hasError) {
      errorHandler(response);
    }
    TodoLabel result = TodoLabel.fromJson(response.body['body']);
    return result;
  }

  Future<void> deleteTodo({required int id}) async {
    final Response response = await delete('/todo/label/$id');
    if (response.hasError) {
      errorHandler(response);
    }
  }
}