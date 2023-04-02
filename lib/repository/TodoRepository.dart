import 'package:get/get.dart';
import 'package:tembird_app/model/Todo.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class TodoRepository extends RootRepository {
  static TodoRepository to = Get.find();

  TodoRepository() {
    initialization();
  }

  Future<Todo> createTodo({required String sid, required Todo todo}) async {
    Map<String, dynamic> data = {
      'sid':sid,
      'todoTitle':todo.todoTitle,
      'todoStatus':todo.todoStatus,
    };
    final Response response = await post('/todo', data);
    if (response.hasError) {
      errorHandler(response);
    }
    Todo result = Todo.fromJson(response.body['body']);
    return result;
  }

  Future<Todo> updateTodo({required Todo todo}) async {
    final Response response = await put('/todo', todo.toJson());
    if (response.hasError) {
      errorHandler(response);
    }
    Todo result = Todo.fromJson(response.body['body']);
    return result;
  }

  Future<void> deleteTodo({required String tid}) async {
    final Response response = await delete('/todo/$tid');
    if (response.hasError) {
      errorHandler(response);
    }
  }
}