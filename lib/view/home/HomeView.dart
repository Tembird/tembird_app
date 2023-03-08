import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/Schedule.dart';
import '../common/ScheduleTable.dart';
import 'controller/HomeController.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            SizedBox(width: 16),
            Text('Tembird'),
          ],
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.onLoading.isTrue
              ? Container(
                  color: Colors.blue,
                )
              : ScheduleTable(
                  scheduleList: controller.scheduleList,
                  onTapSchedule: (Schedule schedule) => controller.showScheduleDetail(schedule),
                  onTapSelectedCell: (List<Point<int>> pointList) => controller.createSchedule(pointList),
                ),
        ),
      ),
    );
  }
}
