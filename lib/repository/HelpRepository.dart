import 'package:get/get.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class HelpRepository extends RootRepository {
  static HelpRepository to = Get.find();

  HelpRepository() {
    initialization();
  }

  Future<String> readAnnouncement() async {
    // TODO : Get Announcement from DB
    String announcement = """<div>
              <h1>공지사항 입니다</h1>
              <h3>제 1조</h3>
              <ul>
                <li>It actually works</li>
                <li>It exists</li>
                <li>It doesn't cost much!</li>
              </ul>
              <h3>제 2조</h3>
              <ul>
                <li>It actually works</li>
                <li>It exists</li>
                <li>It doesn't cost much!</li>
              </ul>
              <!--You can pretty much put any html in here!-->
            </div>""";

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

  Future<void> submitFeedback() async {
    // TODO : Create Feedback on DB
  }
}
