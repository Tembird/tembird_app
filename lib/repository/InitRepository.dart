import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class InitRepository extends RootRepository {
  static InitRepository to = Get.find();

  Future<List<String>> getScheduleColorHexList() async {
    // TODO : Get ScheduleColorHexList from DB
    List<String> codeList = [
      'F9B294', 'ABE874', '8ECAEE', '67C8CF', 'C8D8B4', 'B6C7CF', 'E7A29B', '6ACD95', '979EBA', 'CDA3EF', 'DEB0D9', 'F6CC7C'
    ];

    return codeList;
  }
}