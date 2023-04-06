import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/view/dialog/common/CommonDialogView.dart';

import 'controller/SelectTodoLabelDialogController.dart';

class SelectTodoLabelDialogView extends GetView<SelectTodoLabelDialogController> {
  const SelectTodoLabelDialogView({Key? key}) : super(key: key);

  static route() {
    return GetBuilder(
      init: SelectTodoLabelDialogController(),
      builder: (_) => const SelectTodoLabelDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialogView(
      top: Row(
        children: [
          const Text('카테고리 선택', style: StyledFont.CALLOUT_700),
          Expanded(child: Container()),
          GestureDetector(
            onTap: controller.routeTodoLabelListView,
            child: Image.asset(AssetNames.settingGray, width: 18, fit: BoxFit.contain),
          ),
        ],
      ),
      child: const CategoryItemList(),
    );
  }
}

class CategoryItemList extends GetView<SelectTodoLabelDialogController> {
  const CategoryItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Obx(
        () => controller.onLoading.isTrue
            ? const CategoryItemListSkeleton()
            : Obx(
                () => controller.todoLabelList.isEmpty
                    ? const CategoryItemListEmpty()
                    : Wrap(
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
