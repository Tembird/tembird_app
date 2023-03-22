import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/Announcement.dart';
import 'package:tembird_app/view/help/announcement/controller/AnnouncementController.dart';

class AnnouncementView extends GetView<AnnouncementController> {
  const AnnouncementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: Get.back,
        ),
        title: const Text('공지 사항', style: StyledFont.TITLE_2,),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            Announcement announcement = controller.announcementList[index];
            return GestureDetector(
              onTap: () => controller.showAnnouncement(announcement),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(announcement.type, style: StyledFont.CAPTION_1,)),
                      Text(controller.dateToString(date: announcement.createdAt), style: StyledFont.CAPTION_1_GRAY,),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(announcement.title, style: StyledFont.HEADLINE,),
                ],
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: controller.announcementList.length,
        )),
      ),
    );
  }
}
