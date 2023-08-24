import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/view/dialog/color/select/controller/SelectColorDialogController.dart';
import '../../../../constant/StyledPalette.dart';

class SelectColorDialogView extends GetView<SelectColorDialogController> {
  const SelectColorDialogView({Key? key}) : super(key: key);

  static route({required String? initColorHex}) {
    return GetBuilder(
      init: SelectColorDialogController(initColorHex: initColorHex),
      builder: (_) => const SelectColorDialogView(),
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
                  const Text('색상 선택', style: StyledFont.CALLOUT_700),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: controller.save,
                    child: const Text('완료', style: StyledFont.CALLOUT_INFO),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Expanded(
                  child: controller.colorHexList.isEmpty
                      ? Container()
                      : GridView.count(
                          crossAxisCount: Get.width ~/ 40,
                          children: controller.colorHexList
                              .map(
                                (e) => GestureDetector(
                                  onTap: () => controller.selectColorHex(colorHex: e),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      backgroundColor: e == controller.selectedColorHex.value ? controller.hexToColor(colorHex: e) : StyledPalette.MINERAL,
                                      radius: 16,
                                      child: CircleAvatar(
                                        backgroundColor: controller.hexToColor(colorHex: e),
                                        radius: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
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
