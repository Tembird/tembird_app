import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/view/dialog/common/controller/CommonDialogController.dart';

import '../../../constant/StyledPalette.dart';
import '../../ads/FloatingBannerAdView.dart';

class CommonDialogView extends GetView<CommonDialogController> {
  final Widget top;
  final Widget child;
  const CommonDialogView({Key? key, required this.top, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CommonDialogController(),
      builder: (_) => GestureDetector(
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
                    onTap: controller.close,
                  ),
                ),
              ),
              const FloatingBannerAdView(),
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
                      top,
                      const Divider(),
                      const SizedBox(height: 16),
                      child,
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
