import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/TodoLabel.dart';

import '../../../../component/FloatingBannerAdComponent.dart';
import '../../../../constant/StyledPalette.dart';
import 'controller/SelectTodoLabelDialogController.dart';

class SelectTodoLabelDialogView extends GetView<SelectTodoLabelDialogController> {
  const SelectTodoLabelDialogView({Key? key}) : super(key: key);

  static route({required DateTime date}) {
    return GetBuilder(
      init: SelectTodoLabelDialogController(bannerAdWidth: Get.width, date: date),
      builder: (_) => const SelectTodoLabelDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails details) => controller.bottomSheetVerticalDragStart(details.globalPosition.dy),
      onVerticalDragCancel: controller.bottomSheetVerticalDragCancel,
      onVerticalDragUpdate: (DragUpdateDetails details) => controller.bottomSheetVerticalDragUpdate(details.globalPosition.dy),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top,
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 2,
              width: double.infinity,
              child: GestureDetector(
                onTap: controller.close,
              ),
            ),
            Obx(
              () => controller.bannerAd.value == null ? const SizedBox(height: 66) : FloatingBannerAdComponent(bannerAd: controller.bannerAd.value!),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
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
                          const Text('카테고리 선택', style: StyledFont.CALLOUT_700),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: controller.routeTodoLabelListView,
                            child: Image.asset(AssetNames.settingGray, width: 18, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Expanded(
                        child: CategoryItemList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItemList extends GetView<SelectTodoLabelDialogController> {
  const CategoryItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.onLoading.isTrue
          ? const CategoryItemListSkeleton()
          : Obx(
              () => controller.todoLabelList.isEmpty
                  ? const CategoryItemListEmpty()
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: List.generate(
                          controller.todoLabelList.length,
                          (index) {
                            final TodoLabel todoLabel = controller.todoLabelList[index];
                            final Color todoLabelColor = controller.hexToColor(colorHex: todoLabel.colorHex);
                            return GestureDetector(
                              onTap: () => controller.selectTodoLabel(index: index),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: todoLabelColor,
                                    width: 3,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  todoLabel.title,
                                  style: StyledFont.HEADLINE.copyWith(color: todoLabelColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
    );
  }
}

class CategoryItemListSkeleton extends StatelessWidget {
  const CategoryItemListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO : 로딩 중 스켈레톤
    return Container();
  }
}

class CategoryItemListEmpty extends StatelessWidget {
  const CategoryItemListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '등록된 카테고리가 없습니다',
        style: StyledFont.BODY_GRAY,
      ),
    );
  }
}
