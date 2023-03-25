import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/home/HomeScheduleTable.dart';
import 'package:tembird_app/view/home/TodoList.dart';

import '../../model/Schedule.dart';
import 'controller/HomeController.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    const double rowHeaderWidth = 32;
    const double columnHeaderHeight = 20;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                Image.asset(AssetNames.logoText, width: 100, fit: BoxFit.contain),
              ],
            ),
            const SizedBox(height: 8),
            const HomeTabBar()
          ],
        ),
        actions: [
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: controller.openHelpView,
              child: Image.asset(AssetNames.account, width: 32, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      body: Container(
        color: StyledPalette.MINERAL,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() => IndexedStack(
                  index: controller.viewIndex.value,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: controller.tableWidth,
                          height: 20,
                          color: StyledPalette.MINERAL,
                          padding: EdgeInsets.only(left: 32 - controller.cellWidth / 2),
                          child: Row(
                            children: List.generate(6, (index) => SizedBox(
                              width: controller.cellWidth,
                              child: Text(
                                '${index * 10}',
                                textAlign: TextAlign.center,
                                style: StyledFont.FOOTNOTE,
                              ),
                            )),
                          ),
                        ),
                        const Expanded(
                          child: SingleChildScrollView(
                            child: HomeScheduleTable(),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: TodoList(
                        scheduleList: controller.scheduleList,
                        changeStatus: (Schedule schedule) => controller.changeScheduleStatus(schedule: schedule),
                        onTapTodo: (Schedule schedule) => controller.showScheduleDetail(schedule),
                      ),
                    ),
                  ],
                )),
              ),
              const HomeBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTabBar extends GetView<HomeController> {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: TabBar(
          controller: controller.tabController!,
          padding: const EdgeInsets.only(left: 16),
          indicatorColor: StyledPalette.BLACK,
          isScrollable: true,
          tabs: const [
            Tab(text: "Scheduler"),
            Tab(text: "TodoList"),
          ],
          onTap: controller.selectView,
          labelStyle: StyledFont.CALLOUT_700,
          labelColor: StyledPalette.BLACK,
          unselectedLabelStyle: StyledFont.CALLOUT_GRAY,
          unselectedLabelColor: StyledPalette.GRAY,
        ),
      ),
    );
  }
}

class HomeBottomBar extends GetView<HomeController> {
  const HomeBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.showCalendar,
      child: Container(
        color: StyledPalette.MINERAL,
        height: 52,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(controller.selectedDateText.value, style: StyledFont.HEADLINE)),
            controller.onBottomSheet.isFalse
                ? Image.asset(
                    AssetNames.menuUp,
                    width: 24,
                    fit: BoxFit.contain,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
