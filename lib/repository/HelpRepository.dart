import 'package:get/get.dart';
import 'package:tembird_app/repository/RootRepository.dart';

class HelpRepository extends RootRepository {
  static HelpRepository to = Get.find();

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
    // TODO : Get Terms from DB
    String terms = """<div>
              <h1>서비스 이용약관</h1>
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

    return terms;
  }

  Future<String> readPrivacyPolicy() async {
    // TODO : Get PrivacyPolicy from DB
    String privacyPolicy = """<div>
              <h1>개인정보 처리방침\n</h1><h3>제 1조</h3>
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

    return privacyPolicy;
  }

  Future<void> submitFeedback() async {
    // TODO : Create Feedback on DB
  }
}
