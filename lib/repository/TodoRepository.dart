import 'package:get/get.dart';
import 'package:tembird_app/model/Todo.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class TodoRepository extends RootRepository {
  static TodoRepository to = Get.find();

  TodoRepository() {
    initialization();
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    final Response response = await put('/todo', todo.toJson());
    if (response.hasError) {
      errorHandler(response);
    }
    Todo result = Todo.fromJson(response.body['body']);
    return result;
  }
}