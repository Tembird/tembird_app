import 'package:get/get.dart';
import 'package:tembird_app/repository/HelpRepository.dart';
import 'package:tembird_app/service/RootController.dart';

import '../../../../constant/PageNames.dart';
import '../../../../model/Announcement.dart';
import '../../../common/HtmlView.dart';

class AnnouncementController extends RootController {
  final HelpRepository helpRepository = HelpRepository();
  static AnnouncementController to = Get.find();
  final RxList<Announcement> announcementList = RxList([]);
  final RxBool onLoading = RxBool(true);

  @override
  void onInit() {
    getAnnouncementList();
    super.onInit();
  }

  Future<void> getAnnouncementList() async {
    onLoading.value = true;
    announcementList.clear();
    try {
      List<Announcement> result = await helpRepository.readAnnouncementList();
      announcementList.addAll(result);
    } finally {
      onLoading.value = false;
    }
  }

  void showAnnouncement(Announcement announcement) async {
    onLoading.value = true;
    try {
      Get.toNamed(PageNames.ANNOUNCEMENT_DETAIL, arguments: announcement);
    } finally {
      onLoading.value = false;
    }
  }
}