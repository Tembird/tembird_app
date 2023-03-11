import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/calendar/controller/CalendarController.dart';
import 'package:tembird_app/view/create/schedule/controller/CreateScheduleController.dart';

import '../ads/FloatingBannerAdView.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({Key? key}) : super(key: key);

  static route(DateTime date) {
    return GetBuilder(
      init: CalendarController(initDate: date),
      builder: (_) => const CalendarView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.onLoading.isTrue
          ? Container()
          : GestureDetector(
              onVerticalDragStart: (DragStartDetails details) => controller.dragStart(details.globalPosition.dy),
              onVerticalDragCancel: controller.dragCancel,
              onVerticalDragUpdate: (DragUpdateDetails details) => controller.dragUpdate(details.globalPosition.dy),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: controller.closeCalendar,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.tapAds,
                      child: const FloatingBannerAdView(),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: controller.hideKeyboard,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          color: StyledPalette.MINERAL,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: controller.closeCalendar,
                                  child: const Text('취소', style: StyledFont.CALLOUT_GRAY),
                                ),
                                Expanded(
                                  child: Obx(() => Text(
                                    controller.selectedDateText.value,
                                    style: StyledFont.HEADLINE,
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                                TextButton(
                                  onPressed: controller.confirmCalendar,
                                  child: const Text("완료", style: StyledFont.CALLOUT_INFO),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // TODO : Calendar
                            SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime date) => controller.changeDate(date),
                                minimumDate: DateTime(2023, 01, 01),
                                dateOrder: DatePickerDateOrder.ymd,
                                backgroundColor: StyledPalette.MINERAL,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class TextContent extends GetView<CreateScheduleController> {
  final TextEditingController textEditingController;
  final String title;
  final String hintText;
  final int? maxLines;
  final void Function(String?)? onFieldSubmitted;

  const TextContent({Key? key, required this.textEditingController, required this.title, required this.hintText, this.maxLines, this.onFieldSubmitted}) : super(key: key);

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
          TextFormField(
            controller: textEditingController,
            onTap: controller.onEdit,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: StyledFont.BODY_GRAY,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            maxLines: maxLines,
            style: StyledFont.BODY,
            textAlign: TextAlign.start,
            onFieldSubmitted: onFieldSubmitted,
            textInputAction: maxLines == null ? TextInputAction.newline : TextInputAction.done,
          )
        ],
      ),
    );
  }
}

class WidgetContent extends StatelessWidget {
  final String title;
  final Widget content;

  const WidgetContent({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: StyledFont.CAPTION_1_GRAY,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: content,
        ),
      ],
    );
  }
}

class MemberItem extends StatelessWidget {
  final String name;
  final int index;
  final void Function() onTap;

  const MemberItem(this.index, {Key? key, required this.name, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 40,
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: StyledPalette.GRAY, width: 0.5),
            color: StyledPalette.WHITE,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            name,
            style: StyledFont.BODY,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
