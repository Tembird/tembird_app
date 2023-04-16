import 'package:tembird_app/repository/RootRepository.dart';

class ColorRepository extends RootRepository {
  ColorRepository() {
    initialization();
  }

  Future<List<String>> readAllColorHexList() async {
    final response = await get('/color');
    if(response.hasError) {
      errorHandler(response);
    }
    List<String> list = (response.body['body']['list'] as List).map((e) => e['hex'].toString()).toList();
    return list;
  }
}