import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/home/HomeScheduleTable.dart';
import 'package:tembird_app/view/home/HomeTodoList.dart';

import 'controller/HomeController.dart';

class HomeView extends GetView<HomeController> {
  static String routeName = '/home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Get.width < 500;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 100,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AssetNames.logoText, height: 36, fit: BoxFit.contain),
                  InkWell(
                    onTap: controller.openHelpView,
                    child: Image.asset(AssetNames.account, width: 32, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (isMobile) const HomeTabBar(),
          ],
        ),
      ),
      body: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) => controller.dragHorizontalStart(details.globalPosition.dx),
        onHorizontalDragCancel: controller.dragHorizontalCancel,
        onHorizontalDragUpdate: (DragUpdateDetails details) => controller.dragHorizontalUpdate(details.globalPosition.dx),
        child: Container(
          color: StyledPalette.MINERAL,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMobile)
                  Obx(
                    () => controller.viewIndex.value == 1
                        ? Container(
                            width: controller.tableWidth,
                            height: 20,
                            color: StyledPalette.MINERAL,
                            padding: EdgeInsets.only(left: 32 - controller.cellWidth / 2),
                            child: Row(
                              children: List.generate(
                                  6,
                                  (index) => SizedBox(
                                        width: controller.cellWidth,
                                        child: Text(
                                          '${index * 10}',
                                          textAlign: TextAlign.center,
                                          style: StyledFont.FOOTNOTE,
                                        ),
                                      )),
                            ),
                          )
                        : Container(),
                  ),
                Expanded(
                  child: isMobile
                      ? Obx(() => IndexedStack(
                            index: controller.viewIndex.value,
                            children: const [
                              HomeTodoList(),
                              HomeScheduleTable(),
                            ],
                          ))
                      : Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: controller.tableWidth,
                                    height: 20,
                                    color: StyledPalette.MINERAL,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: List.generate(
                                        6,
                                        (index) => SizedBox(
                                          width: controller.cellWidth,
                                          child: Text(
                                            '${index * 10}',
                                            textAlign: TextAlign.center,
                                            style: StyledFont.FOOTNOTE,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: HomeScheduleTable(),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: HomeTodoList(),
                            ),
                          ],
                        ),
                ),
                const HomeBottomBar(),
              ],
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          indicatorColor: StyledPalette.BLACK,
          isScrollable: false,
          tabs: const [
            Tab(text: "TodoList"),
            Tab(text: "Daily"),
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
          ],
        ),
      ),
    );
  }
}
