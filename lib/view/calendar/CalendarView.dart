import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/calendar/controller/CalendarController.dart';

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
                                initialDateTime: controller.initDate,
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
