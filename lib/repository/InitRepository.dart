import 'package:get/get.dart';
import 'package:tembird_app/model/Update.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class InitRepository extends RootRepository {
  static InitRepository to = Get.find();

  InitRepository() {
    initialization();
  }

  Future<Update> readUpdateInfo() async {
    final response = await get('/update');
    if(response.hasError) {
      errorHandler(response);
    }
    Update result = Update.fromJson(response.body['body']);
    return result;
  }
}