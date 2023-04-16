import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/view/todoLabel/all/controller/AllTodoLabelContoller.dart';

class AllTodoLabelView extends GetView<AllTodoLabelController> {
  static String routeName = '/todoLabel/all';

  const AllTodoLabelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('카테고리 목록'),
        leading: BackButton(
          onPressed: controller.back,
          color: StyledPalette.BLACK,
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: controller.createTodoLabel,
              child: const Icon(
                Icons.add,
                size: 24,
                color: StyledPalette.BLACK,
              ),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final TodoLabel todoLabel = controller.todoLabelList[index];
              return GestureDetector(
                onTap: () => controller.updateTodoLabel(index: index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: controller.hexToColor(colorHex: todoLabel.colorHex),
                        radius: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          todoLabel.title,
                          style: StyledFont.HEADLINE,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.editTodoLabel(index: index),
                        child: const Icon(
                          Icons.more_horiz_outlined,
                          size: 24,
                          color: StyledPalette.BLACK10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemCount: controller.todoLabelList.length,
          ),
        ),
      ),
    );
  }
}
