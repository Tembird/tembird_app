import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';

class ScheduleBottomSheet extends GetView<HomeController> {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: StyledPalette.MINERAL,
      onClosing: controller.closeScheduleBottomSheet,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: controller.deleteSchedule,
                    child: const Text("삭제", style: StyledFont.CALLOUT_NEGATIVE),
                  ),
                  Expanded(
                    child: Text(
                      controller.selectedDateText.value,
                      style: StyledFont.HEADLINE,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.saveSchedule,
                    child: const Text("저장", style: StyledFont.CALLOUT_INFO),
                  ),
                ],
              ),
              Text(controller.selectedScheduleTimeText, style: StyledFont.FOOTNOTE, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Obx(() => Text(controller.selectedSchedule.value!.scheduleTitle, style: StyledFont.TITLE_2_700, textAlign: TextAlign.center)),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    children: [
                      // TODO : [Feat] Text => TextInputForm
                      Obx(() => controller.selectedSchedule.value!.scheduleMember.isEmpty ? Container() : BottomSheetContent(textEditingController: controller.memberController, title: '함께하는 사람', value: controller.selectedSchedule.value!.scheduleMember.map((e) => '@$e ').join())),
                      Obx(() => controller.selectedSchedule.value!.scheduleLocation == null ? Container() : BottomSheetContent(textEditingController: controller.locationController, title: '장소', value: controller.selectedSchedule.value!.scheduleLocation!)),
                      Obx(() => controller.selectedSchedule.value!.scheduleDetail == null ? Container() : BottomSheetContent(textEditingController: controller.detailController, title: '내용', value: controller.selectedSchedule.value!.scheduleDetail!)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: controller.addContent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text('+ 내용 추가', style: StyledFont.HEADLINE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final TextEditingController textEditingController;
  final String title;
  final String value;

  const BottomSheetContent({Key? key, required this.textEditingController, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: StyledFont.CAPTION_1_GRAY,
          ),
          const SizedBox(height: 4),
          InkWell(
              child: Text(
            value,
            style: StyledFont.BODY,
          )),
        ],
      ),
    );
  }
}
