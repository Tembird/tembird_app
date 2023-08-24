import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import 'controller/CalendarController.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({Key? key}) : super(key: key);

  static route(DateTime date) {
    return GetBuilder(
      init: CalendarController(initDate: date, bannerAdWidth: Get.width),
      builder: (_) => const CalendarView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.onLoading.isTrue
          ? Container()
          : GestureDetector(
              onVerticalDragStart: (DragStartDetails details) => controller.bottomSheetVerticalDragStart(details.globalPosition.dy),
              onVerticalDragCancel: controller.bottomSheetVerticalDragCancel,
              onVerticalDragUpdate: (DragUpdateDetails details) => controller.bottomSheetVerticalDragUpdate(details.globalPosition.dy),
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
                    Obx(
                      () => controller.bannerAd.value == null
                          ? Container()
                          : Container(
                              height: 66,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Material(
                                borderRadius: BorderRadius.circular(16),
                                color: StyledPalette.MINERAL,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: AdWidget(ad: controller.bannerAd.value!),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Container(
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
                                child: GestureDetector(
                                  onTap: controller.setDateToday,
                                  child: Obx(
                                    () => Text(
                                      controller.selectedDateText.value,
                                      style: StyledFont.HEADLINE,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: controller.confirmCalendar,
                                child: const Text("완료", style: StyledFont.CALLOUT_INFO),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => CalendarDatePicker(
                              initialDate: controller.selectedDate.value!,
                              firstDate: DateTime(2023, 01, 01),
                              lastDate: DateTime(2099, 12, 31),
                              onDateChanged: controller.changeDate,
                              currentDate: DateTime.now(),
                              initialCalendarMode: DatePickerMode.day,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
