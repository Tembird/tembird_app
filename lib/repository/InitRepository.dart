import 'package:get/get.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class InitRepository extends RootRepository {
  static InitRepository to = Get.find();

  InitRepository() {
    initialization();
  }

  Future<List<String>> readScheduleColorHexList() async {
    final response = await get('/color');
    if(response.hasError) {
      errorHandler(response);
    }
    List<String> list = (response.body['body']['list'] as List).map((e) => e['hex'].toString()).toList();
    return list;
  }
}