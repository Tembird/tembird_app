import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/Announcement.dart';
import 'package:tembird_app/view/help/announcement/controller/AnnouncementController.dart';

class AnnouncementDetailView extends GetView<AnnouncementController> {
  static String routeName = '/announcement/detail';
  const AnnouncementDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Announcement announcement = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: Get.back,
        ),
        title: const Text('상세 내용', style: StyledFont.TITLE_2,),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(announcement.title, style: StyledFont.TITLE_2_700,),
                const Divider(height: 16),
                Text(announcement.content, style: StyledFont.BODY,),
                const Divider(height: 16),
                Text('${controller.dateTimeToString(date: announcement.editedAt)}에 마지막으로 수정됨', style: StyledFont.CAPTION_2, textAlign: TextAlign.end,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
