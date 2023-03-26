import 'dart:convert';

import 'package:get/get.dart';
import 'package:tembird_app/model/Announcement.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class HelpRepository extends RootRepository {
  static HelpRepository to = Get.find();

  HelpRepository() {
    initialization();
  }

  Future<List<Announcement>> readAnnouncementList() async {
    final Response response = await get('/announcement');
    if (response.hasError) {
      errorHandler(response);
    }
    List<Announcement> announcement = (response.body['body']['list'] as List).map((e) => Announcement.fromJson(e)).toList();
    return announcement;
  }

  Future<String> readTerms() async {
    final Response response = await get('/docs/terms');
    if (response.hasError) {
      errorHandler(response);
    }
    String terms = response.body['body']['html'];
    return terms;
  }

  Future<String> readPrivacyPolicy() async {
    final Response response = await get('/docs/privacy-policy');
    if (response.hasError) {
      errorHandler(response);
    }
    String privacyPolicy = response.body['body']['html'];
    return privacyPolicy;
  }

  Future<void> submitFeedback({required String title, required String content}) async {
    Map<String, dynamic> data = {
      'title':title,
      'content':content,
    };
    final Response response = await post('/feedback', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }
}
