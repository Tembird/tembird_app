import 'package:get/get.dart';
import 'package:tembird_app/view/help/announcement/controller/AnnouncementController.dart';

class AnnouncementBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AnnouncementController());
  }
}
